name: 'Submodule Notify EliseFavis.com'

on:
  push:
    branches:
      - main    

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  notify:
    name: 'Submodule Notify Syn Inquisition'
    runs-on: ubuntu-latest

    # Use the Bash shell regardless whether the GitHub Actions runner is ubuntu-latest, macos-latest, or windows-latest
    defaults:
      run:
        shell: bash

    steps:
    - name: Github REST API Call
      env:
        SYN_PUSH: ${{ secrets.SYN_PUSH }}
        PARENT_REPO: Culture-404/Syn_Inquisition
        PARENT_BRANCH: main
        WORKFLOW_ID: 90352237
      run: |
        curl -fL --retry 3 -X POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${{ env.SYN_PUSH }}" https://api.github.com/repos/${{ env.PARENT_REPO }}/actions/workflows/${{ env.WORKFLOW_ID }}/dispatches -d '{"ref":"${{ env.PARENT_BRANCH }}"}'
    
