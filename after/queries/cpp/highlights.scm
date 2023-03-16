; vim: ft=query
(
    (alias_declaration
        name: (type_identifier) @alias.name
        type: (type_descriptor) @alias.type)
    (set! priority 105)
)

(
    (function_declarator
        declarator: (operator_name) @keyword.operator)
    (set! priority 105)
)
(function_definition
    declarator: (function_declarator
        declarator: (qualified_identifier
            name: (operator_name) @keyword.operator)))

(class_specifier
    name: (type_identifier) @class)

(field_declaration
    type: (_) @function.return
    declarator: (function_declarator))
(friend_declaration
    (declaration
        type: (_) @function.return))
(function_definition
    type: (_) @function.return)

(function_declarator
    parameters: (parameter_list
        (parameter_declaration
            type: (_) @function.parameter_type)))
(function_declarator (trailing_return_type (_) @function.return))

; Extern template declaration
(dependent_name (_ (identifier) @keyword))
