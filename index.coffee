"use strict"
class AlwaysUseStrict
    rule:
        name: "strict"
        level: "error"
        message: "Missing \"use strict\" statement"
        description: """
            This rule triggers for each file that does not begin with
            "use strict"

            See also coffeelint-never-use-strict
            """

    lintAST: ({expressions}, {createError}) ->
        if not expressions?.length
            return
        [first, rest...] = expressions
        # skip comments if they exist
        while first?.base?.constructor?.name is 'PassthroughLiteral' and \
              rest.length and \ # not at end of block
              not first.base.value.length # not a backtick expression

            [first, rest] = rest
        if \
                first.constructor.name isnt "Value" or \
                first.base.constructor.name isnt "StringLiteral" or \
                first.base.value not in ['"use strict"', "'use strict'"]
            @errors.push(createError({
                lineNumber: first.locationData.first_line + 1,
                message: "Missing \"use strict\" at top of file"
            }))
        undefined
module.exports = AlwaysUseStrict
