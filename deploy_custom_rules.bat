@echo off
echo Deploying Firestore rules to custom database 'ministore'...

REM Replace with your actual token after running: firebase login:ci
set FIREBASE_TOKEN=your-token-here

REM Read the rules file content
set /p RULES=<firestore.rules

REM Use curl to deploy rules to custom database
curl -X POST ^
  https://firebaserules.googleapis.com/v1/projects/mini-ecommerce-c00f8/rulesets ^
  -H "Authorization: Bearer %FIREBASE_TOKEN%" ^
  -H "Content-Type: application/json" ^
  -d "{\"source\": {\"files\": [{\"content\": \"%RULES%\", \"name\": \"firestore.rules\"}]}}"

echo Rules deployed successfully!