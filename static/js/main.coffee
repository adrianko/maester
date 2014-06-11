(($) ->
    component_stash = {}
    modal = ""
    
    $("a.new-task").on "click", ->
        $('#new-task-modal-title').val("")
        $('#new-task-modal-desc').val("")
        $('#new-task-modal-duration').val("0")
        $('#new-task-modal-duration-unit').val("0")
        $('#new-task-modal-users').val("0")
        modal = $(this).attr('data-category')
        undefined

    $("#new-task-modal-submit").on "click", ->
        if "task" not of component_stash
            #request component structure
            $.get("/api/get/component/task", {}, (data)->
                component_stash.task = data.data
                createTask()
            , "json")
        else
            createTask()
        undefined

    createTask = () ->
        $("div.panel[data-category='"+modal+"'] .panel-body")
            .append(component_stash.task.replace '{{ title }}', $('#new-task-modal-title').val())
        $("#new-task-modal").modal("hide")
        undefined

    undefined
) jQuery
