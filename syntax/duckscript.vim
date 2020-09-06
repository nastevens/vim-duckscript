" Language:   Duckscript
" Maintainer: Nick Stevens <nick@bitcurry.com>
" URL:        https://github.com/nastevens/vim-duckscript
" LICENSE:    MIT

if exists('b:current_syntax')
    finish
endif

" See process_keywords.sh script
syntax match duckKeyword display contained "\v<%(alias|appendfile|array|array_clear|array_concat)>"
syntax match duckKeyword display contained "\v<%(array_contains|array_get|array_is_empty|array_join)>"
syntax match duckKeyword display contained "\v<%(array_length|arrlen|array_size|array_pop|array_push)>"
syntax match duckKeyword display contained "\v<%(array_add|array_put|array_remove|array_set|assert|assert_eq)>"
syntax match duckKeyword display contained "\v<%(assert_error|assert_fail|assert_false|base64|base64_decode)>"
syntax match duckKeyword display contained "\v<%(base64_encode|basename|bytes_to_string|calc|canonicalize)>"
syntax match duckKeyword display contained "\v<%(cat|cd|set_current_dir|set_current_directory|chmod)>"
syntax match duckKeyword display contained "\v<%(clear_scope|concat|contains|cp|cpu_count|get_cpu_count)>"
syntax match duckKeyword display contained "\v<%(current_time|dirname|duckscript_sdk_version)>"
syntax match duckKeyword display contained "\v<%(duckscript_version|dump_instructions|dump_state)>"
syntax match duckKeyword display contained "\v<%(dump_variables|echo|ends_with|env_to_map|equals|eq|eval)>"
syntax match duckKeyword display contained "\v<%(exec|exit_on_error|set_exit_on_error|exit|quit|q|for)>"
syntax match duckKeyword display contained "\v<%(ftp_get|ftp_get_in_memory|ftp_list|ftp_nlst|ftp_put)>"
syntax match duckKeyword display contained "\v<%(ftp_put_in_memory|function|fn|get_all_var_names|get_by_name)>"
syntax match duckKeyword display contained "\v<%(get_env|get_home_dir|get_last_error|get_last_error_line)>"
syntax match duckKeyword display contained "\v<%(get_last_error_source|get_last_modified_time|glob_array)>"
syntax match duckKeyword display contained "\v<%(globarray|glob_chmod|goto|greater_than|hostname|http_client)>"
syntax match duckKeyword display contained "\v<%(if|indexof|is_array|is_command_defined|is_directory|is_dir)>"
syntax match duckKeyword display contained "\v<%(is_empty|is_file|is_map|is_path_exists|is_path_newer)>"
syntax match duckKeyword display contained "\v<%(is_readonly|is_set|is_windows|json_encode|json_parse)>"
syntax match duckKeyword display contained "\v<%(last_indexof|length|strlen|less_than|ls|man|map|map_clear)>"
syntax match duckKeyword display contained "\v<%(map_contains_key|map_contains_value|map_get|map_is_empty)>"
syntax match duckKeyword display contained "\v<%(map_keys|map_load_properties|map_put|map_add|map_remove)>"
syntax match duckKeyword display contained "\v<%(map_size|map_to_properties|mkdir|mv|noop|not|os_family)>"
syntax match duckKeyword display contained "\v<%(os_name|os_release|os_version|pid|process_id|print_env)>"
syntax match duckKeyword display contained "\v<%(printenv|pwd|print_current_directory|random_range)>"
syntax match duckKeyword display contained "\v<%(rand_range|random_text|rand_text|range|read|readbinfile)>"
syntax match duckKeyword display contained "\v<%(read_binary_file|readfile|read_text_file|read_properties)>"
syntax match duckKeyword display contained "\v<%(release|remove_command|replace|rm|rmdir|scope_pop_stack)>"
syntax match duckKeyword display contained "\v<%(scope_push_stack|semver_is_equal|semver_is_newer)>"
syntax match duckKeyword display contained "\v<%(semver_parse|set|set_by_name|set_clear|set_contains|set_env)>"
syntax match duckKeyword display contained "\v<%(set_error|set_from_array|set_is_empty|set_new|set_put)>"
syntax match duckKeyword display contained "\v<%(set_add|set_remove|set_size|set_to_array|sleep|spawn|split)>"
syntax match duckKeyword display contained "\v<%(starts_with|string_to_bytes|substring|temp_dir|temp_file)>"
syntax match duckKeyword display contained "\v<%(test_directory|test_file|touch|trigger_error|trim|trim_end)>"
syntax match duckKeyword display contained "\v<%(trim_start|unalias|uname|unset|unset_all_vars|unset_env)>"
syntax match duckKeyword display contained "\v<%(watchdog|wget|which|whoami|get_user_name|writebinfile)>"
syntax match duckKeyword display contained "\v<%(write_binary_file|writefile|write_text_file)>"
syntax match duckKeyword display contained "\v<%(write_properties)>"
highlight default link duckKeyword Keyword

" Comments
syntax match   duckComment "\v\#.*" contains=@Spell,duckTodo display
syntax keyword duckTodo    TODO XXX FIXME WIP TBD contained
highlight default link duckComment Comment
highlight default link duckTodo Todo

" Command argument types
syntax cluster duckExpr      contains=duckBoolean,duckComment,duckEscape,duckExpansion,duckNumber,duckString
syntax region  duckExpansion start="\v%(\$|\%)\{" end="}" contained display oneline
syntax region  duckString    start='"' skip='\v%(\\|\\")' end='"' contained contains=duckEscape,duckExpansion display oneline
syntax match   duckBoolean   "\v<%(true|yes|false|no)>" contained display
syntax match   duckEscape    "\v\\["nrt\\]" contained display
syntax match   duckNumber    "\v[\+\-]=<\d+>%(\.\d+)=" contained display
highlight default link duckBoolean Boolean
highlight default link duckEscape Special
highlight default link duckExpansion Special
highlight default link duckNumber Number
highlight default link duckString String

" The basic statement types:
" [:label] [output variable =] [command [arguments]]
" !preproc_command [arguments]
syntax cluster duckStatement   contains=duckCommand,duckVariable,duckLabel,duckPreProc,duckComment
syntax match   duckArguments   "\v%(\S+\s*)+$" display contained contains=@duckExpr
syntax match   duckCommand     "\v<\S+>" display contains=duckKeyword nextgroup=duckArguments skipwhite
syntax match   duckCommand     "\v\ze<goto>" display nextgroup=duckGoto skipwhite
syntax match   duckCommand     "\v\ze<for>" display nextgroup=duckForIn skipwhite
syntax match   duckCommand     "\v\ze<if>" display nextgroup=duckIf skipwhite
syntax match   duckCommand     "\v\ze<%(fn|function)>" display nextgroup=duckFn skipwhite
syntax match   duckVariable    "\v\S+>\ze\s*\=" display nextgroup=duckVarAssign skipwhite
syntax match   duckVarAssign   "\v\=" display contained nextgroup=duckCommand skipwhite
syntax match   duckLabel       "\v^\s*\:\S+>" display nextgroup=duckCommand skipwhite
syntax match   duckLabel       "\v^\s*\:\S+>\ze\s+\S+\s*\=" display nextgroup=duckVariable skipwhite
syntax match   duckPreProc     "\v^\s*\!\S+>" display nextgroup=duckArguments skipwhite
highlight default link duckArguments Ignore
highlight default link duckCommand Function
highlight default link duckLabel Special
highlight default link duckPreProc PreProc

" Goto
syntax region duckGoto     matchgroup=duckKeyword start="\v<goto>" end="\v$" contains=duckLabelArg,duckComment
syntax match  duckLabelArg "\v\:\S+" contained
highlight default link duckLabelArg Special

" For
syntax region duckForIn    matchgroup=duckKeyword start="\v<for>" end="\v<in>"me=e-2 nextgroup=duckForInVar skipwhite
syntax region duckForInVar matchgroup=duckKeyword start="\v<in>" end="\v$" contained contains=duckComment nextgroup=duckForBody skipwhite skipempty
syntax region duckForBody  start="\v^" matchgroup=duckKeyword end="\v<end>" contained contains=duckForIn,duckIf,@duckStatement
highlight default link duckForIn Define
highlight default link duckForInVar Special
highlight default link duckForBody String

" If/Else/Elseif
syntax region duckIf     matchgroup=duckKeyword start="\v<if>" end="\v$" contains=@duckExpr nextgroup=duckIfBody skipwhite skipempty
syntax region duckIfBody start="\v^" matchgroup=duckKeyword end="\v<end>" contained contains=duckIf,duckElse,duckElseIf,duckForIn,@duckStatement
syntax region duckElseIf matchgroup=duckKeyword start="\v<elseif>" end="\v$" contained contains=@duckExpr
syntax region duckElse   matchgroup=duckKeyword start="\v<else>" end="\v$" contained contains=duckComment

" Functions
syntax region duckFn       matchgroup=duckKeyword start="\v<%(function|fn)>" end="\v$" contains=duckComment nextgroup=duckFnBody skipwhite skipempty
syntax region duckFnBody   start="\v^" matchgroup=duckKeyword end="\v<end>" contained contains=duckFnReturn,duckFnError,duckForIn,duckIf,@duckStatement
syntax region duckFnError  start="\v<%(function|fn)>" end="\v<end>" contained
syntax region duckFnReturn matchgroup=duckKeyword start="\v<return>" end="\v$" contained contains=@duckExpr
highlight default link duckFn Function
highlight default link duckFnError Error

syntax sync minlines=500

let b:current_syntax = 'duckscript'
