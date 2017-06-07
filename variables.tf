# Settings

variable "account" {
  default = "ads"
}

variable "dns_prefix" {
  default = "ads"
}

variable "location" {
  default = "westeurope"
}

variable "azure_dns_suffix" {
  description = "Azure DNS suffix for the Public IP"
  default = "cloudapp.azure.com"
}

variable "admin_username" {
  default = "admin"
}

variable "admin_password" {
  default = "Passw0rd1234!"
}

variable "ssh" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL8NbtPv3y9930kGW+XvE1qyoDGoNO5eidheCTWALFQdqzMf4yS+Zjgxf0rFKBfPe/CYIIAiSGjxnT+ey/MfwViZRAW8lUGqT3e3aXMW9sk22I3ENI99wqxDEgnxlhS84XmdJAVxGaBSWXnUoJOq4WoR9ineUC0bRN7y31NhQhQFJ8qfu57RSlwSnjg9uCEu69j2RfleQgp696S+mqonx8o8zhkODMGhaBd7hNseBZf2KJQyAHIdMTRSaDnuMTddFY5mv8MK5ikHZyY3huLTKgt6OHtHddH2EStzkC5dtg76c+WNwSjYMlfnqArc9y2l/y4EtCelZCegWkrA/7GzkT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8Q/aUYUr3P1XKVucnO9mlWxOjJm+K01lHJR90MkHC9zbfTqlp8P7C3J26zKAuzHXOeF+VFxETRr6YedQKW9zp5oP7sN+F2gr/pO7GV3VmOqHMV7uKfyUQfq7H1aVzLfCcI7FwN2Zekv3yB7kj35pbsMa1Za58aF6oHRctZU6UWgXXbRxP+B04DoVU7jTstQ4GMoOCaqYhgPHyjEAS3DW0kkPW6HzsvJHkxvVcVlZ/wNJa1Ie/yGpzOzWIN0Ol0t2QT/RSWOhfzO1A2P0XbPuZ04NmriBonO9zR7T1fMNmmtTuK7WazKjQT3inmYRAqU6pe8wfX8WIWNV7OowUjUsv
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDP0q8FlKe+RIhOH0r4voPycbu2cm+MtMfA+wf4nfVQ2twtjHU0LExLDptMVHOuZULMFCJ7rakx78Zc5mJsBQHKT53+HNstfgXMghM0a91yqwq+hBQ5AQtLEq9GQAyygCEXuROvGcQeGD2ScdwRntsVt6KJtDA3wwLwLz3ckGbSM8mgOk2e+c0V5GMAPNWbwDazxvgjFRTsbAEQICrT4AKDj6qcYLjTFucrPEzJUGfDXruMEBUV/5VpDBz3znQ6IR4mH/B01XLRc3EeJJfkZ2VDtl67Y2LeOUW50BI8xn5F0ykvq6nZA+dQOPh5vTP7LUNY7qFr6kFyzN2QpF+f9rXf"
}

variable "count" {
  type = "map"

  default = {
    windows_workers = "1"
    linux_workers = "1"
  }
}

variable "vm_size" {
  default = "Standard_D2_v2"
}
