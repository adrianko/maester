(($) ->
    component_stash = {}
    modal = ""
    task_list_changed = []
    $("a.new-task").on "click", ->
        $("#new-task-modal-title").val("")
        $("#new-task-modal-desc").val("")
        $("#new-task-modal-duration").val("0")
        $("#new-task-modal-duration-unit").val("0")
        $("#new-task-modal-user").val("0")
        modal = $(@).attr("data-category")
        undefined

    $("#new-task-modal-submit").on "click", ->
        component = 0
        if "task" not of component_stash
            component = 1
        $.ajax
            type: "POST"
            url: "/api/set/task/new"
            data:
                component: component
                data:
                    title: $("#new-task-modal-title").val()
                    category: modal
                    order: ($(".panel[data-category='"+modal+"'] .panel-body .well").length + 1)
                    desc: $("#new-task-modal-desc").val()
                    duration: $("#new-task-modal-duration").val()
                    duration_unit: $("#new-task-modal-duration-unit").val()
                    users: JSON.stringify ($(s).val() for s in $("#new-task-modal-users :selected"))
            success: (data) ->
                console.log data
                if component is 1
                    component_stash.task = data.data.components
                createTask(modal, $("#new-task-modal-title").val())
                $("#new-task-modal").modal("hide")
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(".task-list").sortable(
        connectWith: $(".task-list"),
        placeholder: "placeholder"
        change: ->
            id = $(@).closest(".panel").attr("data-category")
            if id not in task_list_changed
                task_list_changed.push id
            console.log task_list_changed
        stop: (e, ui) ->
            order = {}
            for x in task_list_changed
                order[x] = ($(t).attr("data-id") for t in $("div.panel[data-category='"+x+"']").find(".task"))
            console.log order

            $.ajax
                type: "POST"
                url: "/api/set/task/order"
                data:
                    order: JSON.stringify order
                success: (data) ->
                    console.log data
                    if data.code != 200
                        console.log "Error: "+data.code
                error: (jqXHR, textStatus, err) ->
                    console.log err
    ).disableSelection()

    createTask = (category_id, title) ->
        $("div.panel[data-category='"+category_id+"'] .panel-body .task-list")
            .append(component_stash.task.replace "{{ title }}", title)
        null

    undefined
) jQuery
