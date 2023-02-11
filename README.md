# DigiPal to Heurist

These files are for transferring data from the DigiPal project to a custom Heurist database, as part of the research seminar 'Humanités numériques et computationnelles appliquées à l'étude de l'écrit ancien' at the École Pratique des Hautes Études, Université PSL.

The data comes from https://www.digipal.eu and is harvested via the Web API.
It is then processed, reformatted to match the different model, and transformed into Heurist Markup Language for import into [a Heurist database](https://heurist.huma-num.fr/heurist/?db=pstok_sem&website&id=1501).

The files are of four broad types:
 
- `dp_*.xml` : Raw data harvested from the DigiPal web API
- `heu_*_new.xml` : The data transformed into HML format for import
- `heu_*_template.xml` : Template XML files in HML format, as produced by the Heurist database
- `db2heu_*.xsl` : XSLT files for transforming each `dp_*.xml` file into the corresponding `heu_*_new.xml`

The XSLT file combine.xsl simply takes all the `heu_*_new.xml` files and produces a single file `heu_combined_new.xml` which can be imported. This is preferable in principle as it means that all internal keys and references will be automatically handled by Heurist. However, at present the resulting file is larger than the default 2MB limit for Heurist imports.

**Please be aware that this is experimental and very much a work in progress.**

## Further reading

- The DigiPal Project http://digipal.eu
- The Archetype Web API (used by DigiPal): https://github.com/kcl-ddh/digipal/wiki/The-Web-API-Syntax
- The Heurist Database documentation: https://heuristnetwork.org
- The Heurist implementation of DigiPal (*password required*): https://heurist.huma-num.fr/heurist/?db=pstok_sem

Peter A. Stokes, École Pratique des Hautes Études – Université PSL, May 2022
