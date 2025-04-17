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
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        # [Microsoft.SqlServer.Dac.Model.TSqlModel]
        $DacModel,

        # Specifies the separator between schema and table name.
        [Parameter()]
        $SchemaSeparator = '-'
    )

    process {
        $diagram = New-MermaidDiagram -ErDiagram -Config @{ layout = 'elk'}

        $DacModel | Get-DacTable | ForEach-Object {
            $tableString = Get-TableString -NameParts $_.Name.Parts -SchemaSeparator:$SchemaSeparator
            $_ | Get-DacColumn | ForEach-Object {
                $diagram | Add-MermaidErAttribute -Entity $tableString -Name $_.Name.Parts[2] -Type Any
            }
        }

        $DacModel | Get-DacForeignKey | ForEach-Object {
            $sourceTable, $targetTable = $_.GetReferenced() | Where-Object { $_.ObjectType.Name -eq 'Table' }

            if ( $targetTable ) {
                # $keySchemaName, $keyName = $_.Name.Parts

                $sourceTableString = Get-TableString -NameParts $sourceTable.Name.Parts -SchemaSeparator:$SchemaSeparator
                $targetTableString = Get-TableString -NameParts $targetTable.Name.Parts -SchemaSeparator:$SchemaSeparator

                $diagram | Add-MermaidErRelation Zero-or-one $sourceTableString $PSItem.Name.Parts[1] Zero-or-more $targetTableString
            }
            else {
                Write-Verbose "Exclude $( $_.Name ). Foreign table was not found."
            }
        }

        $diagram | ConvertTo-MermaidString | Write-Output
    }

}
