- Use this as a sub module using sub tree

1. Add remote in the parent repo

```shell
git remote add nvim https://github.com/kunkka19xx/nvim.git
```

```shell
git fetch nvim
```

2. Add prefix

```shell
git subtree add --prefix=nvim/.config/nvim nvim main --squash
```

- This command adds child repo (remote name, main branch) into the `nvim/.config/nvim` directory in the parent repo

3. Push changes from parent repo

   Be careful with the prefix (this should be correct)

```shell
git subtree push --prefix=nvim/.config/nvim nvim-config main
```

- If you want to sync anyway, remove --squash from 2nd step
