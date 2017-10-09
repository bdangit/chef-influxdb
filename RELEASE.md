# Release Instructions

## Pre-requisites
- Make sure there are no local branches named `bump`

  ```
  git branch -D bump
  ```

- Ensure you have the following:
  - RubyGems:
    - `bump`
    - `github_changelog_generator`
  - Go:
    - `aktau/github-release`

## Steps

1. Clone the chef-influxdb repository:
  ```
  $ git clone git@github.com:bdangit/chef-influxdb.git
  ```

2. Make sure you are on the master branch and have the latest:
  ```
  $ cd chef-influxdb
  $ git checkout master
  $ git pull origin master
  ```

3. Inside the repo, create a new release:
  ```
  $ cd chef-influxdb
  $ git checkout -b <branch>
  ```

4. Bump the version:
  ```
  $ rake bump
  ```
  > note: It always does a `patch` bump. To do a minor/major bump, set environment variable
  > `BUMPLEVEL` to minor/major (ex. `BUMPLEVEL=minor rake bump`

5. Generate a new `CHANGELOG.md`:

  ```
  $ rake changelog
  ```

6. Commit the `CHANGELOG.md` and `VERSION` changes and push your branch.

7. Issue a new PR await approval.

8. Pull master once again once the PR is merged into master

9. Create & push a Git tag:
  ```
  rake tag
  git push origin --tags
  ```
