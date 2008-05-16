noch zu den URIs & html:link: im moment spuckt hotspot per default javascript:-URIs, ausser man sagt hotspot, er solle http:-URIs rauslassen. im beispiel ist das der fall:

> <configuration>
>   <link subsections="yes" bookmarks="yes"
>     versions="hotspot-example.xml" author="http://dret.net/"
>     help="online" contents="toc.html" glossary="glossary.html"
>     index="index.html" cmSiteNavigationCompatibility="no"/>
>   ...
> </configuration>

wobei @cmSiteNavigationCompatibility='no' den trick macht. damit funktionieren die section- und subsection- und bookmark-einträge mit cmSiteNavigation nicht mehr-- es sei denn, man installiert die angefügte gepatchte (oder gehackte) version. einfach das jar-file am richtigen ort überschreiben (und mit vorteil vorher den feuerfuchs schliessen und ein backup des originalen jars machen). 