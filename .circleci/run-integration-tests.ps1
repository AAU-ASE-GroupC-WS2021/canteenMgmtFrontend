$Passed = @()
$Failed = @()

Get-Item integration_test/*_test.dart -Include $IncludeIntegrationTests -Exclude $ExcludeIntegrationTests `
        | ForEach-Object {
    $TestFile = $_
    $TestName = $TestFile.Name
    Write-Host "Running $TestName" -ForegroundColor DarkYellow
    flutter drive --driver=test_driver/integration_test.dart --target=`"$TestFile`" `
        -d web-server --web-renderer html `
        --dart-define=CI_PROVIDER=IntelliJ `
        --dart-define=GIT_URL=https://github.com/AAU-ASE-GroupC-WS2021/canteenMgmtFrontend `
        --dart-define=GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD) `
        --dart-define=COMMIT_HASH=$(git log -n 1 --pretty=format:"%H")
    If ($LASTEXITCODE -ne 0) {
        $Failed += $TestFile
        Write-Host "$TestName failed" -ForegroundColor DarkRed
    } Else {
        $Passed += $TestFile
        Write-Host "$TestName passed" -ForegroundColor DarkGreen
    }
}

If ($Failed.Length -eq 0) {
    If ($Passed.Length -eq 0) {
        Write-Host "No tests were run. Adjust `$IncludeIntegrationTests and `$ExcludeIntegrationTests." -ForegroundColor DarkYellow
    } Else {
        Write-Host "`n`nAll tests passed." -ForegroundColor DarkGreen
    }
} Else {
    Write-Host "`n`nResults:`n" -ForegroundColor DarkYellow
    $Passed |ForEach-Object { Write-Host "$( $_.Name ) passed" -ForegroundColor DarkGreen }
    $Failed |ForEach-Object { Write-Host "$( $_.Name ) failed" -ForegroundColor DarkRed }
}
