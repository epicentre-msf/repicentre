<img src=https://github.com/user-attachments/assets/b51559e6-31f3-490a-8755-5c65357afddb width=200px>

## What up buttercups.
This is the repo for the revision of the FETCH R course *and* the development of a broader set of R training material for MSF/Epicentre. The ultimate goal is to have a website hosting self contained tutorials providing two possible learning pathways:
1. **Linear:** A specific set of ordered core sessions designed to take students from zero to basic competency
2. **Choose-Your-Own-Adventure**: A repository of core and satellite sessions ranging from basic to advanced topics.

Note, this website is **public** with a **[live development version online](https://epicentre-msf.github.io/repicentre/)**.

## Organization
This project will require several major components, which can be decomposed into *milestones*. Ongoing milestones include:
1. **Admin.** 
2. **Core: Splitting Basic Sessions**
3. **Core: Data Manipulation**
4. **Core: Tables**
5. **Satellite Sessions**
6. **Website and Styling: MVP**
7. **Data: MVP**

For a reminder of what topics we decided to put in to the core vs satellite modules, please refer to the [google sheet](https://docs.google.com/spreadsheets/d/1oqAkFwQVuDzfRouxglN-UT9RMDzl7TLfD5_g0ayPhZU/edit?gid=0#gid=0).

## How to Use this Project
Feel free to add new issues whenever they seem relevant. Many tags are available (including session tags as well as things like "help wanted"). For issues that you own, please give an estimate of the number of days you expect to use slash how many you ultimately used. This will help to make sure we are within the budget in the [project](https://github.com/orgs/epicentre-msf/projects/5/).

## Contribution Protocol and Best Practices
This is a collaborative coding repository with a live prodocution branch. To avoid messiness and possible downstream merge conflicts, we are using a scrum-esque style of development where new ideas are developed through an issue > branch > pull request pathway. Here is a very quick review of what that type of process looks like:

**Note.** here I use [`gh`](https://cli.github.com/) and `git` command line examples but all of these tasks can also be handled from other git managers and/or via GitHub.


**1. When you have an idea for a change (ie: feature request, bug fix, etc), create a [new issue on the project](https://github.com/orgs/epicentre-msf/projects/5/)**

You don't have to be the person who will handle this issue, rather this is just a way of bringing attention to the desired change. Please **do** add a meaningful description of the issue and feel free to add due dates / [labels](https://github.com/epicentre-msf/repicentre/labels) / priority tags as appropriate. Wherever possible, issues should be associated with an ongoing [**Milestone**](https://github.com/epicentre-msf/repicentre/milestones). If you would like to take the issue on, feel free to assign yourself. If you have taken on the issue, please include an estimate of how long you plan to take on it.

You can also create an issue via the command line using: `gh issue create`

**2. When you want to start working on an issue, you should create a branch that is linked to it**

This can be done either [through GitHub](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-a-branch-for-an-issue) or [locally](https://cli.github.com/manual/gh_issue_develop): `gh issue develop {<number> | <url>} [flags]`, ie:

```
# Create a branch for issue 123 and checkout it out
$ gh issue develop 123 --checkout
```

When naming your branch, we encourage the best practice of `[issue-number]-[short-title]`. Once created, you can move between your branches using `git checkout [branch-name]`.

**Warning.** with **very** rare exception branches **should be based on the `main`. Do not create a branch based on another branch.

**3. Use this branch to develop and make commits about your issue (and _only_ that issue)**

**This part is important**, to avoid messy merges and conflicts please make sure that your branches (issues) are self contained and that the branch contains **exclusively** commits related to its respective issue.

**WARNING.** Git(Hub) doesn't always play well with multi-branch iterations of `docs/`. To avoid unnecessary conflicts during the downstream merge, please **do not add, commit, or push** any changes to `docs`. Please do this by simply adding / commiting selectively rather than using a shortcut like `git add *` or `git add .`, please do not change the `.gitignore` to ignore `docs` as this will create problems on the `main`. Whomever reviews your eventual pull request will handle updating the docs render when mergin to the `main`.

**4. Once you have finished working on the issue, submit a pull request and request review**

This requries a couple steps:

- Make sure you are up to date with any changes that happened on the main (note, `merge` is preferred to `rebase` because branches are public):
```
# first make sure your local main is up to date
git checkout main
git pull

# if your local was behind the remote, merge any changes to the main into your branch
git merge [your-issue] main
```

- Make sure that merging the main didn't break anything / fix anything that broke.

- Make sure you have pushed all relevant commits (but none of your changes to `docs`).

- Create a pull request to merge into the main. This can be done either through GitHub on the page of the branch or via:
```
gh pr create
```

**5. Request a review from a code owner**

Because this repo has a live `main`, protection rules have been put in place requiring all merges to the `main` to have a pull request with an approved review. Reviews must be conducted by a code owner; right now this list includes Cat. If you would like to become a code owner, please get in touch!

To notify the code owner that your request is ready for review, assign a code owner as a reviewer and send a review request via GitHub.

**6. Wait for the merge**

The reviewer may get in touch requesting more information or moditications. Once all modifications have been resolved and the review is passed, the reviewer will merge the pull request.

**7. Delete the branch**

Once merged, best practices recommend deleting the branch both locally and on the remote to avoid congestion. This can be done via:
```
git push -d <remote_name> <branchname>   # Delete remote
git branch -d <branchname>               # Delete local
```

**Note.** It is possible / likely that the reviewer who merged the pull request deleted the relevant remote, in this case you only need to delete your local version.

That's it! If you have any questions or need some assistance with your first issues / pull requests, please don't hesitate to reach out to Cat for help.
