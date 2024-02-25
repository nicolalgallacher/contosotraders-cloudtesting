param profiles_MyFrontDoor_name string = 'MyFrontDoor'

resource profiles_MyFrontDoor_name_resource 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: profiles_MyFrontDoor_name
  location: 'Global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  kind: 'frontdoor'
  properties: {
    originResponseTimeoutSeconds: 30
    // Remove the assignment of an empty object to the read-only property "extendedProperties"
    // extendedProperties: {}
  }
}

resource profiles_MyFrontDoor_name_afd_a36hikcu3pd7w 'Microsoft.Cdn/profiles/afdendpoints@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_resource
  name: 'afd-a36hikcu3pd7w'
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource profiles_MyFrontDoor_name_apis 'Microsoft.Cdn/profiles/afdendpoints@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_resource
  name: 'apis'
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource profiles_MyFrontDoor_name_images 'Microsoft.Cdn/profiles/afdendpoints@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_resource
  name: 'images'
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource profiles_MyFrontDoor_name_cartapiorigingroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_resource
  name: 'cartapiorigingroup'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource profiles_MyFrontDoor_name_imagesgroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_resource
  name: 'imagesgroup'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource profiles_MyFrontDoor_name_MyOriginGroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_resource
  name: 'MyOriginGroup'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 0
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource profiles_MyFrontDoor_name_prodapiorigingroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_resource
  name: 'prodapiorigingroup'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource profiles_MyFrontDoor_name_cartapiorigingroup_cartapiorigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_cartapiorigingroup
  name: 'cartapiorigin'
  properties: {
    hostName: 'contoso-traders-cartapijjjj.westeurope.cloudapp.azure.com'
    httpPort: 80
    httpsPort: 443
    originHostHeader: 'contoso-traders-cartapijjjj.westeurope.cloudapp.azure.com'
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: false
  }
}

resource profiles_MyFrontDoor_name_imagesgroup_imagesorigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_imagesgroup
  name: 'imagesorigin'
  properties: {
    hostName: 'contosotradersimgjjjj.blob.core.windows.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: 'contosotradersimgjjjj.blob.core.windows.net'
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: false
  }
}

resource profiles_MyFrontDoor_name_prodapiorigingroup_prodapiorigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_prodapiorigingroup
  name: 'prodapiorigin'
  properties: {
    hostName: 'contoso-traders-prodapijjjj.westeurope.cloudapp.azure.com'
    httpPort: 80
    httpsPort: 443
    originHostHeader: 'contoso-traders-prodapijjjj.westeurope.cloudapp.azure.com'
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: false
  }
}

resource profiles_MyFrontDoor_name_MyOriginGroup_webstorare 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_MyOriginGroup
  name: 'webstorare'
  properties: {
    hostName: 'contosotradersui2jjjj.z6.web.core.windows.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: 'contosotradersui2jjjj.z6.web.core.windows.net'
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}

resource profiles_MyFrontDoor_name_apis_cartroute 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_apis
  name: 'cartroute'
  properties: {
    customDomains: []
    originGroup: {
      id: profiles_MyFrontDoor_name_cartapiorigingroup.id
    }
    ruleSets: []
    supportedProtocols: ['Http', 'Https']
    patternsToMatch: ['/cart/*']
    forwardingProtocol: 'HttpOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
}

resource profiles_MyFrontDoor_name_afd_a36hikcu3pd7w_MyRoute 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_afd_a36hikcu3pd7w
  name: 'MyRoute'
  properties: {
    customDomains: []
    originGroup: {
      id: profiles_MyFrontDoor_name_MyOriginGroup.id
    }
    ruleSets: []
    supportedProtocols: ['Http', 'Https']
    patternsToMatch: ['/*']
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
}

resource profiles_MyFrontDoor_name_apis_prodroute 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_apis
  name: 'prodroute'
  properties: {
    customDomains: []
    originGroup: {
      id: profiles_MyFrontDoor_name_prodapiorigingroup.id
    }
    ruleSets: []
    supportedProtocols: ['Http', 'Https']
    patternsToMatch: ['/prod/*']
    forwardingProtocol: 'HttpOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Disabled'
    enabledState: 'Enabled'
  }
}

resource profiles_MyFrontDoor_name_images_routetoimages 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: profiles_MyFrontDoor_name_images
  name: 'routetoimages'
  properties: {
    customDomains: []
    originGroup: {
      id: profiles_MyFrontDoor_name_imagesgroup.id
    }
    ruleSets: []
    supportedProtocols: ['Http', 'Https']
    patternsToMatch: ['/*']
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
}
