(($) ->
    component_stash = {}
    task_category = ""
    task_order = []
    task_open = ""
    edit_item = ""

    window.taskSortable = () ->
        $(".task-list").sortable(
            connectWith: $(".task-list")
            placeholder: "placeholder"
            change: ->
                id = $(@).closest(".panel").attr "data-category"
                if id not in task_order
                    task_order.push id
            stop: (e, ui) ->
                order = {}
                for x in task_order
                    order[x] = ($(t).attr "data-task" for t in $("div.panel[data-category='"+x+"']").find ".task")
                $.ajax
                    type: "POST"
                    url: "/api/set/task/order"
                    data:
                        order: JSON.stringify order
                    success: (data) ->
                        if data.code != 200
                            console.log "ERROR: "+data.code
                    error: (jqXHR, textStatus, err) ->
                        console.log err
        ).disableSelection()
        null

    window.taskSortable()

    $(document.body).on "click", "a.new-task", ->
        $("#new-task-modal-title").val ""
        $("#new-task-modal-desc").val ""
        $("#new-task-modal-duration").val "0"
        $("#new-task-modal-duration-unit").val "0"
        $("#new-task-modal-users .selectable-user").removeClass "selected"
        task_category = $(@).attr "data-category"
        undefined

    $(document.body).on "click", "#new-task-modal-submit", ->
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
                    category: task_category
                    order: ($(".panel[data-category='"+task_category+"'] .panel-body .well").length + 1)
                    desc: $("#new-task-modal-desc").val()
                    duration: $("#new-task-modal-duration").val()
                    duration_unit: $("#new-task-modal-duration-unit").val()
                    users: JSON.stringify ($(s).attr "data-user" for s in $("#new-task-modal-users div.selected"))
            success: (data) ->
                if component is 1
                    component_stash.task = data.data.components
                task = component_stash.task
                task = task.replace "{{ title }}", $("#new-task-modal-title").val()
                task = task.replace "{{ id }}", data.data.id
                $("div.panel[data-category='"+task_category+"'] .panel-body .task-list")
                    .append(task)
                $("#new-task-modal").modal "hide"
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".task-remove", ->
        $("#task-details-modal").modal "hide"
        $(".task[data-task='"+task_open+"']").parent().remove()
        $.ajax
            type: "POST"
            url: "/api/set/task/delete"
            data:
                id: task_open
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".task", ->
        task_open = $(@).attr "data-task"
        $.ajax
            type: "GET"
            url: "/api/get/task/"+task_open
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                else
                    data = data.data[0]
                    $("#task-title").text data.title
                    $("#task-description").text data.description
                    duration = data.duration
                    if duration < 1800
                        duration = ""
                    else if duration >= 1800 and duration < 86400
                        duration = (duration / 3600) + "hr"
                    else if duration >= 86400 and duration < 604800
                        duration = (duration / 86400) + "dy"
                    else if duration >= 604800 and duration < 2419200
                        duration = (duration / 604800) + "wk"
                    else
                        duration = (duration / 2419200) + "mo"
                    $("#task-duration").text duration
                    $("#task-assignee ul.users").text ""
                    for u in data.users
                        $("#task-assignee ul.users").append "<li>"+u.username+"</li>"
                    $(".task-detail-field").editable()
                    $(".task-detail-field").off "click"
                    $("#task-details-modal").modal "show"
        undefined

    $(".task-detail-container").hover(
        -> $(@).children(".edit-item").css "display", "inline-block"
        -> $(@).children(".edit-item").css "display", "none"
    )

    $(document.body).on "click", ".edit-item", (e) ->
        e.preventDefault()
        e.stopPropagation()
        $(@).parent().find(".editable").editable "toggle"
        edit_item = $(@).attr "data-item"
        undefined

    $(document.body).on "click", ".editable-submit", (e) ->
        value = $(".editable-input .form-control").val()
        $.ajax
            type: "POST"
            url: "/api/set/task/update"
            data:
                id: task_open
                field: edit_item
                value: value
            success: (data) ->
                console.log data
                if edit_item == "title"
                    $(".task[data-task='"+task_open+"']").text value
                $(".task-detail-field").removeClass "editable-unsaved"
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".selectable-user", ->
        $(@).toggleClass "selected"
        undefined
) jQuery
