# *schematron4define*

## Description

The main purpose of *schematron4define* is to perform Define-XML validation by combining W3C XML Schema and Schematron.

## Requirements

This project makes use of the following software:

- **Apache Ant** ([download](https://downloads.apache.org/ant/)) This project uses version 1.10.12. An Ant version that supports the *xslt* and *schemavalidate* tasks is required to run the validation.
- **JDK 8** or higher.
- **Saxon-HE** ([Saxonica](https://www.saxonica.com/download/java.xml)) This project uses version 11.6. This version is available in the project.

## Running the validation

Open a terminal (command-prompt) in the **ant** folder. The following command validates an SDTM Define-XML file (../xml/sdtm/define.xml) against the Define-XML v2.1 schema and creates the define21_sdtm.html validation report. It uses the build.properties properties file.

```SHELL
ant
```

To validate the ADaM Define-XML example against the Define-XML v2.1 schema, enter the following command:

```SHELL
ant -Ddefine.xml=../xml/adam/define.xml -Dreport.html=define21_adam.html
```

Notice that the last validation will throw some errors because the ADaM Define-XML file contains Analysis Results Metadata.
The following example validates the ADaM Define-XML file (including Analysis Results Metadata) against the Define-XML 2.1 schema that includes Analysis Results Metadata.

```SHELL
ant -propertyfile build_arm.properties
```

The result of the validation can be found in define21_adam_arm.html.

## Contribution

Contribution is very welcome. When you contribute to this repository you are doing so under the below licenses. Please checkout [Contribution](CONTRIBUTING.md) for additional information. All contributions must adhere to the following [Code of Conduct](CODE_OF_CONDUCT.md).

## License

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg) ![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-blue.svg)

### Code & Scripts

This project is using the [MIT](http://www.opensource.org/licenses/MIT "The MIT License | Open Source Initiative") license (see [`LICENSE`](LICENSE)) for code and scripts.

### Content

The content files like documentation and minutes are released under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/). This does not include trademark permissions.

## Re-use

When you re-use the source, keep or copy the license information also in the source code files. When you re-use the source in proprietary software or distribute binaries (derived or underived), copy additionally the license text to a third-party-licenses file or similar.

When you want to re-use and refer to the content, please do so like the following:

> Content based on [Project schematron4define (GitHub)](https://github.com/lexjansen/schematron4define) used under the [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) license.
