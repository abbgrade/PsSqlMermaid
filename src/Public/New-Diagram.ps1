function New-Diagram {

    <#

    .SYNOPSIS
    Creates an ER diagram for a Dac model.

    .DESCRIPTION
    Uses PsDac to select the tables and foreign key constrains from a database model and creates a mermaid Entity Relationship diagrams.

    .EXAMPLE

    PS C:\> Import-DacModel WideWorldImporters.dacpac | New-SqlMermaidDiagram

    <svg id="mermaid-1639919827409" width="100%" xmlns="http://www.w3.org/2000/svg" ...

    #>

    [CmdletBinding()]
    param (

        # Specifies the database model.
        [Parameter(
            ValueFromPipeline
        )]
        # [Microsoft.SqlServer.Dac.Model.TSqlModel]
        $DacModel,

        # Specifies the separator between schema and table name.
        [Parameter()]
        $SchemaSeparator = '-'
    )

    process {
        $diagram = New-MermaidDiagram -Type erDiagram

        $includedTables = $()

        $DacModel | Get-DacForeignKey | ForEach-Object {
            $sourceTable, $targetTable = $_.GetReferenced() | Where-Object { $_.ObjectType.Name -eq 'Table' }

            if ( $targetTable ) {
                $sourceSchemaName, $sourceTableName = $sourceTable.Name.Parts
                $targetSchemaName, $targetTableName = $targetTable.Name.Parts
                $keySchemaName, $keyName = $_.Name.Parts

                $sourceTableString = "$sourceSchemaName$SchemaSeparator$sourceTableName"
                $targetTableString = "$targetSchemaName$SchemaSeparator$targetTableName"

                $diagram | Add-MermaidRelation Zero-or-one $sourceTableString $PSItem.Name.Parts[1] Zero-or-more $targetTableString

                $includedTables += $sourceTable, $targetTable | ForEach-Object { $_.Name.ToString() }
            }
            else {
                Write-Verbose "Exclude $( $_.Name ). Foreign table was not found."
            }
        }

        $includedTables = $includedTables | Select-Object -Unique

        $DacModel | Get-DacTable | Where-Object {
            -Not ( $includedTables -contains $_.Name.ToString() )
        } | ForEach-Object {
            $schemaName, $tableName = $_.Name.Parts
            $tableString = "$schemaName$SchemaSeparator$tableName"
            $diagram | Add-MermaidRelation -Entity $tableString
        }

        $diagram | ConvertTo-MermaidString | Write-Output
    }

}
