// --------------------------------------------------------------------------------
// Main Bicep file that creates all of the Azure Resources for one environment
// --------------------------------------------------------------------------------
param appName string = take('myapp${uniqueString(resourceGroup().id)}',12)
@allowed(['dev','demo','qa','stg','ct','prod'])
param environmentCode string = 'dev'
param location string = resourceGroup().location

// this is a parameter because I can use the function here - I never expect it to be passed
param runDateTime string = utcNow()

// --------------------------------------------------------------------------------
// a suffix to put on all of the deployment names to make them unique
var deploymentSuffix = '-${runDateTime}'

// Tags that are common to all resources
var commonTags = {         
  LastDeployed: runDateTime
  Application: appName
  Environment: environmentCode
}

// --------------------------------------------------------------------------------
module resourceNames 'resourcenames.bicep' = {
  name: 'resourcenames${deploymentSuffix}'
  params: {
    appName: appName
    environmentCode: environmentCode
  }
}
// --------------------------------------------------------------------------------
module logAnalyticsWorkspaceModule 'loganalytics.bicep' = {
  name: 'logAnalytics${deploymentSuffix}'
  params: {
    workspaceName: resourceNames.outputs.logAnalyticsWorkspaceName
    location: location
    commonTags: commonTags
  }
}
