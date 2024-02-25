param frontdoorname string = 'MyFrontDoor'
param productapicname string
param cartapicname string
param imagescname string
param webstorecname string
param resourceTags object

resource frontDoorProfile 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: frontdoorname
  location: 'Global'
  tags: resourceTags
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  // Remove the assignment of the value 'frontdoor' to the read-only property "kind"
  // kind: 'frontdoor'
  properties: {
    originResponseTimeoutSeconds: 30
    // Remove the assignment of an empty object to the read-only property "extendedProperties"
    // extendedProperties: {}
  }
}

resource frontDoorProfile_web 'Microsoft.Cdn/profiles/afdendpoints@2022-11-01-preview' = {
  parent: frontDoorProfile 
  name: 'web'
  location: 'Global'
  tags: resourceTags
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorProfile_apis 'Microsoft.Cdn/profiles/afdendpoints@2022-11-01-preview' = {
  parent: frontDoorProfile
  name: 'apis'
  location: 'Global'
  tags: resourceTags
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorProfile_images 'Microsoft.Cdn/profiles/afdendpoints@2022-11-01-preview' = {
  parent: frontDoorProfile
  name: 'images'
  location: 'Global'
  tags: resourceTags
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorProfile_cartapiorigingroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: frontDoorProfile
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

resource frontDoorProfile_imagesgroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: frontDoorProfile
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

resource frontDoorProfile_webOriginGroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: frontDoorProfile
  name: 'WebOriginGroup'
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

resource frontDoorProfile_prodapiorigingroup 'Microsoft.Cdn/profiles/origingroups@2022-11-01-preview' = {
  parent: frontDoorProfile
  name: 'prodApiOriginGroup'
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

resource frontDoorProfile_cartapiorigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: frontDoorProfile_cartapiorigingroup
  name: 'cartApiOrigin'
  properties: {
    hostName: cartapicname
    httpPort: 80
    httpsPort: 443
    originHostHeader: cartapicname
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: false
  }
}

resource frontDoorProfile_imagesorigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: frontDoorProfile_imagesgroup
  name: 'imagesOrigin'
  properties: {
    hostName: imagescname
    httpPort: 80
    httpsPort: 443
    originHostHeader: imagescname
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: false
  }
}

resource frontDoorProfile_prodapiorigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: frontDoorProfile_prodapiorigingroup
  name: 'prodApiOrigin'
  properties: {
    hostName: productapicname
    httpPort: 80
    httpsPort: 443
    originHostHeader: productapicname
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: false
  }
}

resource frontDoorProfile_weborigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-11-01-preview' = {
  parent: frontDoorProfile_webOriginGroup
  name: 'webStoreOriginGroup'
  properties: {
    hostName: webstorecname
    httpPort: 80
    httpsPort: 443
    originHostHeader: webstorecname
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}

resource frontDoorProfile_cart_route 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: frontDoorProfile_apis
  name: 'cartroute'
  properties: {
    customDomains: []
    originGroup: {
      id: frontDoorProfile_cartapiorigingroup.id
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

resource frontDoorProfile_web_route 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: frontDoorProfile_web
  name: 'MyRoute'
  properties: {
    customDomains: []
    originGroup: {
      id: frontDoorProfile_webOriginGroup.id
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

resource frontDoorProfile_apis_prod_route 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: frontDoorProfile_apis
  name: 'prodroute'
  properties: {
    customDomains: []
    originGroup: {
      id: frontDoorProfile_prodapiorigingroup.id
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

resource frontDoorProfile_images_route 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-11-01-preview' = {
  parent: frontDoorProfile_images
  name: 'routetoimages'
  properties: {
    customDomains: []
    originGroup: {
      id: frontDoorProfile_imagesgroup.id
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

// return the 3 endpoints
output webEndpoint string = frontDoorProfile_web.properties.hostName
output imagesEndpoint string = frontDoorProfile_images.properties.hostName
output VmApiEndpoint string = frontDoorProfile_apis.properties.hostName
