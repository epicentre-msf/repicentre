 What up buttercups. <img src='img/llama.svg' width=200px align='right'>
----------------------------------------------------------------------------------------------------
Welcome to the R training repo, thanks for being here! A few quick notes:
- Want to write a new session? Amazing, read the "Notes on Session Development" section. 
- Someone told you to review a session? We thank you for your service, please read the "Session Review Guidelines" section.
- Need some tips on best practices for collaborative coding? Read the "General Contribution Guidelines"

Note, this website is **public** with a **[live development version online](https://epicentre-msf.github.io/repicentre/)**. Please don't break it!


Notes on session development.
----------------------------------------------------------------------------------------------------
Want to write a session? **Amazing.** Here are some tips:
- Make sure you **open an issue saying that you will draft that session** and assign yourself to it then make a branch to work on it. Please use the naming style `<short_name-session/satellite>`, for example `import-session` or `dates-satellite`.
- If you are working on a **core session**, put it in `sessions_core` and use the filename convention `[session number]_[session name].qmd`, for example `02_import.qmd`.
- If you are working on a satellite, put files in `sessions_extra` and give your file a short but descriptive name.
- If you need to embedd any images, put them in the relevant subfolder of `img` in **the root directory**, every session with images should have it's own subfolder in either `img/core/` or `img/extra/` as appropriate.
- When you are done building your session, you can move on to the review and pull request process -- more information on those below.

**NB.** For a reminder of what topics we decided to put in to the core vs satellite modules, please refer to the [google sheet](https://docs.google.com/spreadsheets/d/1oqAkFwQVuDzfRouxglN-UT9RMDzl7TLfD5_g0ayPhZU/edit?gid=0#gid=0).


Session review guidelines.
----------------------------------------------------------------------------------------------------
Once a session has been developped, it is important that someone reviews it to:  

1. Make sure the length is appropriate (for example, sessions should take us around 15 minutes to complete)
2. Verify that the content covers the main concept of the session 
3. Check on the information load (keep in mind the students just got into R, let's try and only retain essential information as it's already a lot for them)
4. Check spelling and syntax
5. Check styling (make sure callouts/tooltip are used consistently and there are no style bugs)

The first thing to do is to open a github issue `review session-name` and assign it to yourself. Review both the `.qmd` and the `.html` file (inside `docs`) for the session. If you see any spelling or minors mistakes feel free to correct them directly in the `.qmd `.

More important changes should be introduced as comments (see below commenting with hypothes.is) and discussed with the person who developped the session. Once you are done with the review drop a message on the issue, try to summarise your thoughts on the session and list major suggested changes. The issue can serve as a forum to discuss/resolve/vote on points of contention. 

### Commenting
To review a session we use a commenting system called [hypothes.is](https://web.hypothes.is/) that allows us to direclty comment/annotate the `.html` file the same way you would do in a word document. In order to use it, you need to set the hypothesis comments portion of the YAML to true:

```
comments: 
    hypothesis: true
```

With hypothes.is we can:

1. Drop a page note for the overall page 
2. Highlight some text 
3. Highlight text and annotate - other users can then reply to this comment

Comments are pretty robust and will stay on the html file even when we rerender! If the text that you selected for the comment is not there anymore, the comment will be an **orphan**, still visible on the document but not attached to any text. It looks like we cannot attach it back to a portion of the text but at least there is no lose of information.

Please start all of your comments with `[YOUR-NAME]` in front of it, otherwise we loose track of authors when sharing comments. Once you are happy with the comments, you need to extract them as a `.JOSN` format, and drop the file in the github issue that you created earlier (`review session-name`). These can then be downloaded and imported inside hypothes.is to be read by the session author. They can also reply to comments (including `[THEIR-NAME]`, re-export them, and post them as a reply to the issue. 

Once the session is completed and feedback resolved, we need to manually delete all of the comments and set the hypothesis option in the YAML back to `false`: 

```
comments: 
    hypothesis: false
```

General contribution guidelines.
----------------------------------------------------------------------------------------------------
This is a collaborative coding repository with a live production branch. To avoid messiness and possible downstream merge conflicts, we are using a scrum-esque style of development where new ideas are developed through an issue > branch > pull request pathway. Below is a quick explanation of what that process looks like, but TLDR:

![Image](https://github.com/user-attachments/assets/9d01d859-bdf0-47d8-8a49-e0d217aeff71)


Continue reading if you want more information about any of these steps. **Note.** here we use [`gh`](https://cli.github.com/) and `git` command line examples but all of these tasks can also be handled from other git managers (github desktop) and/or via GitHub.

**1. When you have an idea for a change (ie: feature request, bug fix, etc), create a [new issue on the project](https://github.com/orgs/epicentre-msf/projects/5/)**

You don't have to be the person who will handle this issue, rather this is just a way of bringing attention to the desired change. Please **do** add a meaningful description of the issue and feel free to add due dates / [labels](https://github.com/epicentre-msf/repicentre/labels) / priority tags as appropriate. Wherever possible, issues should be associated with an ongoing [**Milestone**](https://github.com/epicentre-msf/repicentre/milestones). If you would like to take the issue on, feel free to assign yourself. If you have taken on the issue, please include an estimate of how long you plan to take on it.

You can also create an issue via the command line using: `gh issue create`

**2. When you want to start working on an issue, you should create a branch that is linked to it**

This can be done either [through GitHub](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-a-branch-for-an-issue) or [locally](https://cli.github.com/manual/gh_issue_develop): `gh issue develop {<number> | <url>} [flags]`, ie:

```
# Create a branch for issue 123 and checkout it out
$ gh issue develop 123 --checkout
```

When naming your branch, we encourage the best practice of `[issue-number]-[short-title]`. Once created, you can move between your branches using `git checkout [branch-name]`. You can list all existing branches (and see which one you are on) with `git branch -a`

**Warning.** with **very** rare exception branches **should be based on the `main`. Do not create a branch based on another branch.

**3. Use this branch to develop and make commits about your issue (and _only_ that issue)**

**This part is important**, to avoid messy merges and conflicts please make sure that your branches (issues) are self contained and that the branch contains **exclusively** commits related to its respective issue. It is worth noting that merge conflicts are pretty common for the `docs` directory. In those cases, it is recommended to checkout the most recent version of `docs` and [commit it to your working branch using `--theirs`](https://nitaym.github.io/ourstheirs/). If you aren't familiar with using `--ours` and `--theirs` please don't hesitate to reach out for help.

**4. Once you have finished working on the issue, submit a pull request.**
Note, if you are developing a new session, you should go through the pedagogic review process outlined earlier before proceeding to the pull request.

This requires a couple steps:

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

**5. Request a code review from a code owner**

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
