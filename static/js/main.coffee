(($) ->
    component_stash = {}
    modal = ""
    task_list_changed = []
    task_open = ""
    $(document.body).on "click", "a.new-task", ->
        $("#new-task-modal-title").val("")
        $("#new-task-modal-desc").val("")
        $("#new-task-modal-duration").val("0")
        $("#new-task-modal-duration-unit").val("0")
        $("#new-task-modal-user").val("0")
        modal = $(@).attr("data-category")
        undefined

    $(document.body).on "click", "a.new-category", ->
        $("#new-category-modal-title").val("")
        undefined

    $(document.body).on "click", "a.new-board", ->
        $("#new-board-modal-title").val("")
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
                    category: modal
                    order: ($(".panel[data-category='"+modal+"'] .panel-body .well").length + 1)
                    desc: $("#new-task-modal-desc").val()
                    duration: $("#new-task-modal-duration").val()
                    duration_unit: $("#new-task-modal-duration-unit").val()
                    users: JSON.stringify ($(s).val() for s in $("#new-task-modal-users :selected"))
            success: (data) ->
                if component is 1
                    component_stash.task = data.data.components
                createTask(modal, $("#new-task-modal-title").val(), data.data.id)
                $("#new-task-modal").modal("hide")
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined
    taskSortable = () ->
        $(".task-list").sortable(
            connectWith: $(".task-list")
            placeholder: "placeholder"
            change: ->
                id = $(@).closest(".panel").attr("data-category")
                if id not in task_list_changed
                    task_list_changed.push id
            stop: (e, ui) ->
                order = {}
                for x in task_list_changed
                    order[x] = ($(t).attr("data-id") for t in $("div.panel[data-category='"+x+"']").find(".task"))
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
        undefined
    taskSortable()

    $(".categories").sortable(
        handle: ".reorder"
        placeholder: "placeholder-category"
        stop: (e, ui) ->
            console.log $(".categories").eq(0).attr("data-board-id")
            $.ajax
                type: "POST"
                url: "/api/set/category/order"
                data:
                    id: $(".categories").eq(0).attr("data-board-id")
                    order: JSON.stringify ($(c).attr("data-category") for c in $("div.categories").find(".category"))
                success: (data)->
                    if data.code != 200
                        console.log "ERROR: "+data.code
                    console.log data
                error: (jqXHR, textStatus, err) ->
                    console.log err
    ).disableSelection()


    $(document.body).on "click", ".task-remove", ->
        $("#task-details-modal").modal("hide")
        $(".task[data-id='"+task_open+"']").parent().remove()
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
        task_open = $(@).attr('data-id')
        $.ajax
            type: "GET"
            url: "/api/get/task/"+task_open
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                else
                    $("#task-title").text(data.data[0].title)
                    $("#task-description").text(data.data[0].description)
                    duration = data.data[0].duration
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
                    $("#task-duration").text(duration)
                    $("#task-assignee ul.users").text("")
                    for u in data.data[0].users
                        $("#task-assignee ul.users").append("<li>"+u.username+"</li>")
                    $("#task-details-modal").modal("show")
        undefined

    $("#new-category-modal-submit").on "click", ->
        component = 0
        if "category" not of component_stash
            component = 1
        title = $("#new-category-modal-title").val()
        $.ajax
            type: "POST"
            url: "/api/set/category/new"
            data:
                component: component
                id: $(".new-category:first").attr("data-board-id")
                title: title
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                if component is 1
                    component_stash.category = data.data.components
                category = component_stash.category
                category = category.split "{{ c.id }}"
                category = category.join data.data.id
                category = category.replace "{{ c.title }}", title
                $("div.categories").append(category)
                $("#new-category-modal").modal("hide")
                taskSortable()
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $("#new-board-modal-submit").on "click", ->
        title = $("#new-board-modal-title").val()
        $("#new-board-modal").modal("hide")
        $.ajax
            type: "POST"
            url: "/api/set/board/new"
            data:
                title: title
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $(".boards:first").append("<li class=\"list-group-item\"><a href=\"/board/"+data.data.id+"\">"+title+"</a></li>")
            error: (jqXHR, textStatus, err) ->
                console.log err

    createTask = (category_id, title, id) ->
        task = component_stash.task
        task = task.replace "{{ title }}", title
        task = task.replace "{{ id }}", id
        $("div.panel[data-category='"+category_id+"'] .panel-body .task-list")
            .append(task)
        null

    undefined
) jQuery
