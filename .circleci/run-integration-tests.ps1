$TestDir = "integration_test"
$DriverDir = "$TestDir/test_driver"
$FixtureDir = "$TestDir/fixtures"

$global:Passed = @()
$global:Failed = @()

Function Run-FlutterIntegrationTest {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Target,
        [String]$Driver = "$DriverDir/integration_test.dart",
        [Switch]$IgnoreResult = $false,
        [String]$Args = ""
    )
    $TargetFile = Get-Item $Target
    $TestName = $TargetFile.BaseName

    Write-Host "Applying fixtures for $TestName" -ForegroundColor DarkYellow

    $SqlFixtures = @("$FixtureDir/reset.sql")
    if (Test-Path "$FixtureDir/$TestName.sql") {
        $SqlFixtures += "$FixtureDir/$TestName.sql"
    }
    $env:PGPASSWORD="mysecretpassword"
    cat $SqlFixtures | psql -h 127.0.0.1 -p 5432 -d postgres -U postgres -q -f -
    $env:PGPASSWORD=""

    Write-Host "Running $TestName" -ForegroundColor DarkYellow

    flutter drive --driver=`"$Driver`" --target=`"$Target`" `
        -d web-server --web-renderer html `
        --dart-define=CI_PROVIDER=IntelliJ `
        --dart-define=GIT_URL=https://github.com/AAU-ASE-GroupC-WS2021/canteenMgmtFrontend `
        --dart-define=GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD) `
        --dart-define=COMMIT_HASH=$(git log -n 1 --pretty=format:"%H") `
        $Args

    If (-not $IgnoreResult) {
        If ($LASTEXITCODE -ne 0) {
            $global:Failed += "$TestName"
            Write-Host "$TestName failed" -ForegroundColor DarkRed
        } Else {
            $global:Passed += "$TestName"
            Write-Host "$TestName passed" -ForegroundColor DarkGreen
        }
    }
}

Run-FlutterIntegrationTest -Target "$TestDir/qr_scan_test.dart" -Driver "$DriverDir/screenshot_test.dart" `
    -Args "--dart-define=SCREENSHOT=ON" -IgnoreResult


Get-Item "$TestDir/*_test.dart" -Include $IncludeIntegrationTests -Exclude $ExcludeIntegrationTests `
    | ForEach-Object { Run-FlutterIntegrationTest -Target $_ }

If ($Failed.Length -eq 0) {
    If ($Passed.Length -eq 0) {
        Write-Host "No tests were run. Adjust `$IncludeIntegrationTests and `$ExcludeIntegrationTests." -ForegroundColor DarkYellow
    } Else {
        Write-Host "`n`nAll tests passed." -ForegroundColor DarkGreen
    }
} Else {
    Write-Host "`n`nResults:`n" -ForegroundColor DarkYellow
    $Passed |ForEach-Object { Write-Host "$_ passed" -ForegroundColor DarkGreen }
    $Failed |ForEach-Object { Write-Host "$_ failed" -ForegroundColor DarkRed }
}
