# 🐊 Team Crocodile 🐊

## Welcome to your new project!

**One** of your teammates should clone this repository to their machine. Then, go through these steps:

1. Add a `.gitignore` to the cloned directory. The [Github suggested one for Swift](https://github.com/github/gitignore/blob/master/Swift.gitignore) is a good start.
2. Uncomment the `Pods/` line in the `.gitignore`. We want to ignore the Pods directory. Trust me on this.
3. Add a line in the `.gitignore` that just says `Secrets.swift` (or `Constants.swift`, your preference) to the `.gitignore`. We want git to ignore your API keys and secrets, since this is going to be open source. Make sure the name of the Secrets file you create matches the name you enter here.
4. Make a new Xcode project in the cloned directory.
5. Run `pod init` in the directory, and add a pod (any pod, maybe something like Snapkit) to the `Podfile`. Then run `pod install`. This will set up the workspace for the project, so everyone starts on the same foot.
6. Add a `Secrets.swift` file to your project (using `File > New > Cocoa Class`).
7. In terminal, you'll probably need to do `git reset HEAD` and then `git add .`. This is just necessary when making changes to the `.gitignore`.
8. Once you've done that, run `git status` and ensure that the `Secrets.swift` file and `<username>.xcuserdata` files are **not** in the list.
9. Commit! `git commit -m "Initial Commit"`
10. Push! `git push origin master`

Now your teammates can clone this repository and start branching and coding!
