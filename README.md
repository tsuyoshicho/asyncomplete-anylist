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
