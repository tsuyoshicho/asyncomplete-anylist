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
