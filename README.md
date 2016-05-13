# lgt
show the Latest Github repos with the most stars that you haven't seen before with this simple shell script

---

# WHY?

I was tired of going through hundreds of repos on github.com/trending to find new repos I haven't seen before. This script makes GitHub API calls to get repos with the most stars, and makes a plain-text archive of repos you've seen so you don't see them again.

# Usage

Running lgt without arguments for the first time will return trending repos for c,cpp,shell, and will create the following heirarchy in $HOME:
```
|--.lgt/
       |--languages  #list of languages to get trending repos of. Add langs directly to this file
       |--archive    #list of repos you've already seen so you don't see them again
```

You can add langauges to ~/.lgt/languages

Running lgt with a language as the first argument will get repos for just that language. Multiple languages can be specified in quotes separated by spaces.
