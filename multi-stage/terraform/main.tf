variable org_service_url {}

variable personal_access_token {}

variable github_personal_access_token {}

provider azuredevops {
  version = ">= 0.0.1"
  org_service_url = var.org_service_url
  personal_access_token = var.personal_access_token
}

data azuredevops_project project {
  project_name = "Cloud-Native"
}

// this is resolved successfully, but there is a bug that prevents it being used in azuredevops_build_definition below
data azuredevops_git_repositories azdo_repository {
  project_id = data.azuredevops_project.project.id
  name = "azdo-pipeline-design"
}

output azdo_repository_id {
  value = data.azuredevops_git_repositories.azdo_repository.id
}

resource azuredevops_serviceendpoint_github github {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "Sample GithHub Personal Access Token"

  auth_personal {
    personal_access_token = var.github_personal_access_token
  }
}

resource azuredevops_build_definition pipeline {
  project_id = data.azuredevops_project.project.id
  name = "azdo-pipeline-design-multi-stage"
  repository {
    repo_id = "fernandoespinosa/azdo-pipeline-design"
    repo_type = "GitHub"
    yml_path = "/multi-stage/pipeline.yaml"
    service_connection_id = azuredevops_serviceendpoint_github.github.id
  }
  ci_trigger {
    use_yaml = true
  }
}