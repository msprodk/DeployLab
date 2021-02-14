, //Microsoft.Resources/deployments/ConfigClient
        {
            "name": "ConfigClient",
            "type": "Microsoft.Resources/deployments",
            "apiVersion": "2019-09-01",
            "dependsOn": [
                "[resourceId('Microsoft.Resources/deployments', 'UpdateNICCLIENT')]",
                "[resourceId('Microsoft.Compute/virtualMachines/extensions', variables('vmNameCLIENT'), 'PrepareCLIENT'))]"
            ],
            "properties": {
                "mode": "Incremental",
                "templateLink": {
                    "uri": "[variables('templateUriConfigureCLIENT')]",
                    "contentVersion": "1.0.0.0"
                },
                "parameters": {
                    "Name": {
                        "value": "[variables('vmNameCLIENT')]"
                    },
                    "location": {
                        "value": "[parameters('ResourceGroup')]"
                    },
                    "adminUsername": {
                        "value": "[parameters('adminUsername')]"
                    },
                    "adminPassword": {
                        "value": "[parameters('adminPassword')]"
                    },
                    "domainName": {
                        "value": "[parameters('domainName')]"
                    },
                    "ConfigFunction": {
                        "value": "[variables('functionConfigurationCLIENT')]"
                    },
                    "ConfigModulesURL": {
                        "value": "[variables('modulesURLConfigurationCLIENT')]"
                    }
                }
            }
        }