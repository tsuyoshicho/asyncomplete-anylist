# asyncomplete-anylist

Configurable list source for [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) plugin.

## Settings

```vim
autocmd User asyncomplete_setup call
\ asyncomplete#register_source(
\   asyncomplete#sources#anylist#get_source_options({
\     'name': 'anylist',
\     'allowlist': ['*'],
\     'completor': function('asyncomplete#sources#anylist#completor'),
\     'config': {
\       'matcher': '\(\w\|\f\)+$',
\       'items': {
\         {'name': 'fixed', 'list': ["Username", "Data"]},
\         {'name': 'func', 'func': function(s:gen), 'args': []},
\       }
\     },
\     'priority': 20,
\   }))
function! s:gen() abort
  return ['Destination', 'Example']
endfunction
```
