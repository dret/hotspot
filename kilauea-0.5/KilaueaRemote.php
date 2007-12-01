<?php

// $Id$
 
//////////////////////////////
// includes

include_once("JSON.php");

/**
 * Copyright © 2007 Felix Michel
 * 
 * 
 * This file is part of Kilauea.
 * 
 * Kilauea is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Kilauea is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. You can find it as a file called 'COPYING.txt'
 * in the topmost directory of Kilauea.
 * If not, see <http://www.gnu.org/licenses/>.
 */


//////////////////////////////
// configuration variables

$sessionDir = "/tmp";		// system tmp
//$sessionDir = "sessions";	// local tmp dir, if writable

$pollTimeout = 100;			// in milliseconds
$keepaliveTimeout = 10;		// in seconds

$legalActions = array("new", "shutdown", "list");



//////////////////////////////
// say no to code injection

$params = null;

function parseGetParams() {
	global $_GET, $params, $legalActions;
	
	// params:
	//   i = ID
	//   p = slide position
	//   v = unveiled incrementals
	//   a = action
	//   m = is master
	//   n = legible name
	//   c = coordinates
	
	if (isset($_GET['i'])) {
		if (preg_match('/^\d{4}$/', $_GET['i']) == 0) {
			signalError(406, "Illegal session ID (4-digit number required)");
		} else {
			$params->id->defined = TRUE;
			$params->id->value = $_GET['i'];
		}
	} else {
		$params->id->defined = FALSE;
	}
	
	if (isset($_GET['p'])) {
		if (preg_match('/^\d+$/', $_GET['p']) == 0) {
			signalError(406, "Illegal slide position");
		} else {
			$params->pos->defined = TRUE;
			$params->pos->value = $_GET['p'];
		}
	} else {
		$params->pos->value = 0;
		$params->pos->defined = FALSE;
	}
	
	if (isset($_GET['v'])) {
		if (preg_match('/^\d+$/', $_GET['v']) == 0) {
			signalError(406, "Illegal incremental position");
		} else {
			$params->inc->defined = TRUE;
			$params->inc->value = $_GET['v'];
		}
	} else {
		$params->inc->value = 0;
		$params->inc->defined = FALSE;
	}
	
	if (isset($_GET['a'])) {
		if (!in_array($_GET['a'], $legalActions)) {
			signalError(406, "Illegal action");
		} else {
			$params->action->defined = TRUE;
			$params->action->value = $_GET['a'];
		}
	} else {
		$params->action->defined = FALSE;
	}
	
	if (isset($_GET['m'])) {
		$params->master->defined = TRUE;
		$params->master->value = (boolean) $_GET['m'];
	} else {
		$params->master->defined = FALSE;
		$params->master->value = FALSE;
	}
	
	if (isset($_GET['n'])) {
		$params->name->defined = TRUE;
		$params->name->value = preg_replace('/[^\d\s\w]/', "", $_GET['n']);
	} else {
		$params->name->defined = FALSE;
	}
	
	if (isset($_GET['c'])) {
		$coords = array();
		if (preg_match('/(\d{1,3})\,(\d{1,3})/', $_GET['c'], $coords) != 1) {
			signalError(406, "Illegal coordinates");
		} else {
			$params->coord->defined = TRUE;
			$params->coord->value->x = $coords[1];
			$params->coord->value->y = $coords[2];
		}
	} else {
		$params->coord->defined = FALSE;
	}
	
}



//////////////////////////////////////////////
// let's go!!

parseGetParams();


if ($params->action->defined && $params->action->value == 'new') {

	if ($params->name->defined && $params->name->value != "") {
		
		$id = rand(1000, 9999);
		$file = "$sessionDir/kilauearemote-".$id.".txt";
		if (file_exists($file)) {
			signalError(500, "Duplicate ID error");
		}
		if (!($fh = @fopen($file, 'w'))) {
			signalError(500, "Cannot open file");
		}
		$session = "{name: '".$params->name->value."', pos: ".$params->pos->value."}";
		fwrite($fh, $session);
		fclose($fh);
		
		header("HTTP/1.1 201 Created");
		echo "{".$id.": ".$session."}";
	} else {
		signalError("No name specified");
	}
	
} else if ($params->action->defined && $params->action->value == 'list') {

	header("HTTP/1.1 200 Sessions List");
	echo listConnections();
	
} else if ($params->action->defined && $params->action->value == 'shutdown') {

	if ($params->id->defined) {
		$file = "$sessionDir/kilauearemote-".$params->id->value.".txt";
		if (!file_exists($file)) {
			signalError(404, "Invalid session");
		}
		// best effort delete
		header("HTTP/1.1 200 Ok");
		readfile($file);
		@unlink($file);
	}
	
} else {

	if ($params->id->defined) {
		
		$file = "$sessionDir/kilauearemote-".$params->id->value.".txt";
		if (!file_exists($file)) {
			signalError(404, "Invalid session ID (Session may have been closed by foreign host)");
		}
		if ($params->master->value) {
			if (update($file)) {
				header("HTTP/1.1 204 No Content");
			} else {
				signalError(500, "Update Failed");
			}
		} else {
			switch(poll($file)) {
				case 0:
//					header("HTTP/1.1 304 Not modified");
//					break;
				case 1:
					header("HTTP/1.1 200 Ok");
					readfile($file);
					break;
				case -1:
				default:
					signalError(408, "Session closed by foreign host");
			}
		}
	}
	
}



//////////////////////////////
// functions

function signalError($code, $msg) {
	header("HTTP/1.1 $code $msg");
	echo $msg;
	exit();
}

function listConnections() {
	global $sessionDir;
	
	$obj = "{";
	$data = array();
	
	foreach (glob("$sessionDir/kilauearemote-*.txt") as $file) {
		$fh = @fopen($file, 'r');
		$content = fread($fh, 8096);
		if ($content) {
			$data[] = substr($file, strpos($file, "kilauearemote-") + 14, 4).": $content";
		}
		fclose($fh);
	}
	
	return "{".implode(',', $data)."}";
}


function poll($file) {
	global $pollTimeout, $keepaliveTimeout, $params;
	
	if (!($fh = @fopen($file, 'r'))) {
		return -1;
	}
	$old = fread($fh, 8096);
	fclose($fh);

	$json = new Services_JSON();
	$status = $json->decode($old);
	
	if (!$params->pos->defined ||
	    $status->pos != $params->pos->value ||
	    !$params->inc->defined ||
	    $status->inc != $params->inc->value ||
	    $status->pointer && !$params->coord->defined ||
	    !$status->pointer && $params->coord->defined ||
	    $status->pointer->x != $params->coord->value->x ||
	    $status->pointer->y != $params->coord->value->y
	    ) {
			return 1;
	}
	
	for($i = 0; $i < (1000 / $pollTimeout) * $keepaliveTimeout; $i++) {
		if (!($fh = @fopen($file, 'r'))) {
			return -1;
		}
		$new = fread($fh, 8096);
		fclose($fh);
		if ($new != $old) {
			return 1;
		}
		usleep($pollTimeout * 1000);
	}
	return 0;
}


function update($file) {
	global $params;
	
	if (!($fh = @fopen($file, 'r'))) {
		return FALSE;
	}
	$old = fread($fh, 8096);
	fclose($fh);
	
	$json = new Services_JSON();
	$status = $json->decode($old);
		
	// pointer
	if ($params->coord->defined) {
		$status->pointer->x = $params->coord->value->x;
		$status->pointer->y = $params->coord->value->y;
	} else {
		unset($status->pointer);
	}
	
	// position
	if ($params->pos->defined) {
		$status->pos = $params->pos->value;
	}
	// incremental
	if ($params->inc->defined) {
		$status->inc = $params->inc->value;
	}
	
	if (!($fh = @fopen($file, 'w'))) {
		return FALSE;
	}
	flock($fh, LOCK_EX);
	fwrite($fh, $json->encode($status));
	fclose($fh);
	
	return TRUE;
}



?>