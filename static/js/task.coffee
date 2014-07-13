(($) ->
    component_stash = {}
    task_category = ""
    task_order = []
    task_open = ""

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

    window.convertDuration = (d) ->
        duration = d
        duration_unit = ""
        if duration < 1800
            duration = ""
        else if duration >= 1800 and duration < 43200
            duration = (duration / 3600)
            duration_unit = "hr"
        else if duration >= 43200 and duration < 604800
            duration = (duration / 86400)
            duration_unit = "dy"
        else if duration >= 604800 and duration < 2419200
            duration = (duration / 604800)
            duration_unit = "wk"
        else
            duration = (duration / 2419200)
            duration_unit = "mo"
        return {} =
            duration: duration
            duration_unit: duration_unit

    saveTaskDetails = () ->
        title = $("#edit-task-modal-title").val()
        description = $("#edit-task-modal-desc").val()
        duration = $("#edit-task-modal-duration").val()
        duration_unit = $("#edit-task-modal-duration-unit").val()
        users = JSON.stringify ($(s).attr "data-user" for s in $("#edit-task-modal-users .selected"))
        $("#task-title").text title
        $(".task[data-task='"+task_open+"'] .title").text title
        $("#task-description").text description
        $("#task-users .users").text ""
        for s in $("#edit-task-modal-users .selected")
            $("#task-users .users").append "<li>"+$(s).text()+"</li>"
        $.ajax
            type: "POST"
            url: "/api/set/task/update"
            data:
                id: task_open
                title: title
                description: description
                duration: duration+duration_unit
                users: users
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                d = window.convertDuration(data.data.data.duration)
                $("#task-duration [data-subitem='duration']").text d.duration
                $("#task-duration [data-subitem='duration-unit']").text d.duration_unit
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

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
                    users: JSON.stringify ($(s).attr "data-user" for s in $("#new-task-modal-users .selected"))
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
        $("#delete-task-modal").modal "show"

    $(document.body).on "click", "#delete-task-yes", ->
        $(".task[data-task='"+task_open+"']").parent().remove()
        $.ajax
            type: "POST"
            url: "/api/set/task/delete"
            data:
                id: task_open
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $("#delete-task-modal").modal "hide"
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", "#delete-task-no", ->
        $("#delete-task-modal").modal "hide"
        $("#task-details-modal").modal "show"
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
                    $("#edit-task-modal-title").val data.title
                    $("#task-description").text data.description
                    $("#edit-task-modal-desc").val data.description
                    d = window.convertDuration(data.duration)
                    duration = d.duration
                    duration_unit = d.duration_unit
                    $("#task-duration span[data-subitem='duration']").text duration
                    $("#edit-task-modal-duration").val duration
                    $("#task-duration span[data-subitem='duration-unit']").text duration_unit
                    $("#edit-task-modal-duration-unit").val duration_unit.charAt(0)
                    $("#task-users ul.users").text ""
                    $("#edit-task-modal-users").find(".selectable-user").removeClass "selected"
                    for u in data.users
                        $("#task-users ul.users").append "<li>"+u.username+"</li>"
                        $("#edit-task-modal-users").find("[data-user='"+u.id+"']").addClass "selected"
                    $("#task-details-modal").modal "show"
        undefined

    $(".task-detail-container").hover(
        -> $(@).find(".edit-item").css "display", "inline-block"
        -> $(@).find(".edit-item").css "display", "none"
    )

    $(document.body).on "click", ".edit-item", (e) ->
        e.preventDefault()
        e.stopPropagation()
        item = $(@).attr "data-item"
        if $(".task-item-detail-edit:visible").length > 0
            saveTaskDetails()
        $(".task-item-detail-view").show()
        $(".task-item-detail-edit").hide()
        $(@).closest(".task-detail-container").find(".task-item-detail-view[data-item='"+item+"']").hide()
        $(@).closest(".task-detail-container").find(".task-item-detail-edit[data-item='"+item+"']").show()
        undefined

    $(document.body).on "click", ".task-item-detail-edit", (e) ->
        e.preventDefault()
        e.stopPropagation()
        undefined

    $(document.body).on "click", "#task-details-modal", (e) ->
        e.preventDefault()
        e.stopPropagation()
        if $(".task-item-detail-edit:visible").length > 0
            saveTaskDetails()
        $(".task-item-detail-edit").hide()
        $(".task-item-detail-view").show()
        undefined

    $(document.body).on "click", ".selectable-user", ->
        $(@).toggleClass "selected"
        undefined

) jQuery
