---
external help file: PsSqlMermaid-help.xml
Module Name: PsSqlMermaid
online version:
schema: 2.0.0
---

# New-SqlMermaidDiagram

## SYNOPSIS
Creates an ER diagram for a Dac model.

## SYNTAX

```
New-SqlMermaidDiagram [[-DacModel] <Object>] [[-SchemaSeparator] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Uses PsDac to select the tables and foreign key constrains from a database model and creates a mermaid Entity Relationship diagrams.

## EXAMPLES

### EXAMPLE 1
```
Import-DacModel WideWorldImporters.dacpac | New-SqlMermaidDiagram
```

\<svg id="mermaid-1639919827409" width="100%" xmlns="http://www.w3.org/2000/svg" ...

## PARAMETERS

### -DacModel
Specifies the database model.
\[Microsoft.SqlServer.Dac.Model.TSqlModel\]

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SchemaSeparator
Specifies the separator between schema and table name.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: -
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
