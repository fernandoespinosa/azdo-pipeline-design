variable org_service_url {}

variable personal_access_token {}

provider "azuredevops" {
  version = ">= 0.0.1"
  org_service_url = var.org_service_url
  personal_access_token = var.personal_access_token
}

data "azuredevops_project" "project" {
  project_name = "Cloud-Native"
}

data "azuredevops_git_repositories" "repository" {
  project_id = data.azuredevops_project.project.id
  name = "azdo-pipeline-design"
}

resource "azuredevops_build_definition" "pipeline" {
  project_id = data.azuredevops_project.project.id
  name = "azdo-pipeline-design-multi-stage"
  repository {
    repo_id = data.azuredevops_git_repositories.repository.id
    repo_type = "TfsGit"
    yml_path = "multi-stage/pipeline.yaml"
  }
}