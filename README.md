# asyncomplete-anylist

Configurable list source for [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) plugin.

## Settings

```vim
function! s:gen() abort
  return ['tips', 'tomorrow']
endfunction

autocmd User asyncomplete_setup call
\ asyncomplete#register_source(
\   asyncomplete#sources#anylist#get_source_options({
\     'name': 'anylist',
\     'allowlist': ['*'],
\     'completor': function('asyncomplete#sources#anylist#completor'),
\     'config': {
\       'matcher': '\(\w\|\f\)+$',
\       'items': [
\         {'name': 'sign', 'list': ['tsuyoshicho']},
\         {'name': 'func', 'function': function('s:gen'), 'args': []},
\       ],
\     },
\     'priority': 20,
\   }))
```

![sample result](https://github.com/tsuyoshicho/asyncomplete-anylist/blob/assets/images/asyncomplete-anylist-sample-1.png)

## Configuration description

anylist is need `config` entry in `get_source_options`'s arguments.

* config is a dictionary.
* config.matcher is string, that is "pattern" to use for completion matching.
* config.items is a list of dictionaries.

The item of config.items can define the following contents.

* item.name : A string, the name that will appear in the completion menu.
* item.list : A list of strings, used for completion. (High priority than item.function)
* item.function : A Funcref that returns a list of strings.
* item.args : A list, that is arguments passed when calling item.function.

## Useful examples

```vim
" https://www.conventionalcommits.org/en/v1.0.0/
function! s:git_conventional_commit() abort
  if &filetype =~? 'git'
    return [
    \  'build', 'ci', 'chore', 'docs', 'feat', 'fix',
    \  'perf', 'refactor', 'revert', 'style', 'test'
    \]
  endif
  return []
endfunction

autocmd User asyncomplete_setup call
\ asyncomplete#register_source(
\   asyncomplete#sources#anylist#get_source_options({
\     'name': 'anylist',
\     'allowlist': ['*'],
\     'completor': function('asyncomplete#sources#anylist#completor'),
\     'config': {
\       'matcher': '\(\w\|\f\)+$',
\       'items': [
\         {'name': 'sign', 'list': ['tsuyoshicho', 'tsuyoshi_cho']},
\         {'name': 'git', 'function': function('s:git_conventional_commit'), 'args': []},
\         {'name': 'mrw', 'function': function('mr#mrw#list'), 'args': []},
\       ],
\     },
\     'priority': 20,
\   }))
```

* sign: User account completion. Completion work always.
* git:  Conventional Commits completion. Completion work under git related filetypes.
* mrw:  [mr.vim](https://github.com/lambdalisue/mr.vim)'s most recently write file list completion. Completion work always.
