# ToDo

Below is a list of "nice to have" or FIXME not completed due to a matter of time:
- FIXME, use punctual ARN for resources inside custom_policy
- "nice to have", add an AWS Codebuild project that takes as input the new repositories (the output from the already done projects), it uses them with the helm (already done) to generate the Kubernetes manifests and deploy them to EKS
- FIXME, inside the app.Docker I should checkout a specific branch and make it a parameter, in this way codebuild could select the build branch

