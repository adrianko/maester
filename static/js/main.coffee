(($) ->
    $("a.new-task").on "click", ->
        $('#new-task-modal-title').val("")
        $('#new-task-modal-desc').val("")
        $('#new-task-modal-duration').val("0")
        $('#new-task-modal-duration-unit').val("0")
        $('#new-task-modal-users').val("0")
        undefined
    undefined
) jQuery
