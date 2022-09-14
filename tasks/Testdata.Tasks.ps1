. $PSScriptRoot/PsSqlTestTasks/SqlServerSamples.Tasks.ps1
. $PSScriptRoot/PsSqlTestTasks/WideWorldImporters.Tasks.ps1

task Testdata.Create -Jobs PsSqlTestTasks.WideWorldImporters.DacPac.Create
