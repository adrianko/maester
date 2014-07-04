(($) ->
    component_stash = {}
    new_task_category = ""
    task_list_changed = []
    task_open = ""
    home_board = ""
    del_category = ""
    board_id = ""

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
        null

    taskSortable()

    $(document.body).on "click", "a.new-task", ->
        $("#new-task-modal-title").val("")
        $("#new-task-modal-desc").val("")
        $("#new-task-modal-duration").val("0")
        $("#new-task-modal-duration-unit").val("0")
        $("#new-task-modal-user").val("0")
        new_task_category = $(@).attr("data-category")
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
                    category: new_task_category
                    order: ($(".panel[data-category='"+new_task_category+"'] .panel-body .well").length + 1)
                    desc: $("#new-task-modal-desc").val()
                    duration: $("#new-task-modal-duration").val()
                    duration_unit: $("#new-task-modal-duration-unit").val()
                    users: JSON.stringify ($(s).val() for s in $("#new-task-modal-users :selected"))
            success: (data) ->
                if component is 1
                    component_stash.task = data.data.components
                task = component_stash.task
                task = task.replace "{{ title }}", $("#new-task-modal-title").val()
                task = task.replace "{{ id }}", data.data.id
                $("div.panel[data-category='"+new_task_category+"'] .panel-body .task-list")
                    .append(task)
                $("#new-task-modal").modal("hide")
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

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
                    data = data.data[0]
                    $("#task-title").text(data.title)
                    $("#task-description").text(data.description)
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
                    $("#task-duration").text(duration)
                    $("#task-assignee ul.users").text("")
                    for u in data.users
                        $("#task-assignee ul.users").append("<li>"+u.username+"</li>")
                    $("#task-title").editable()
                    $("#task-description").editable()
                    $("#task-details-modal").modal("show")
        undefined

    $(document.body).on "click", "#new-category-modal-submit", ->
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

    $(document.body).on "click", "#new-board-modal-submit", ->
        component = 0
        if "boarditem" not of component_stash
            component = 1
        title = $("#new-board-modal-title").val()
        $("#new-board-modal").modal("hide")
        $.ajax
            type: "POST"
            url: "/api/set/board/new"
            data:
                component: component
                title: title
            success: (data) ->
                console.log data
                if data.code != 200
                    console.log "ERROR: "+data.code
                if component is 1
                    component_stash.boarditem = data.data.components
                board = component_stash.boarditem
                board = board.split "{{ id }}"
                board = board.join data.data.id
                board = board.replace "{{ title }}", title
                $(".boards").eq(0).append(board)
                $("#new-board-modal").modal("hide")
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".board-link", ->
        window.location.href = $(@).attr("data-href")
        undefined

    $(document.body).on "click", ".board-edit", ->
        board_id = $(@).parent().parent().closest("li").attr("data-board")
        $("#edit-board-modal-title").val($(@).closest(".btn-group").find(".board-link").eq(0).text())
        $("#edit-board-modal").modal("show")
        undefined

    $(document.body).on "click", "#edit-board-modal-submit", ->
        title = $("#edit-board-modal-title").val()
        $.ajax
            type: "POST"
            url: "/api/set/board/update"
            data:
                id: board_id
                title: title
            success: (data) ->
                console.log data
                if data.code != 200
                    console.log "ERROR: "+data.code
                $("ul.boards li[data-board='"+board_id+"'] .btn-group .board-link").text(title)
                $("#edit-board-modal").modal("hide")
                board_id = ""
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".board-delete", ->
        home_board = $(@).attr("data-id")
        $("#delete-board-modal").modal('show')
        undefined

    $(document.body).on "click", "#delete-board-no", ->
        $("#delete-board-modal").modal('hide')
        undefined

    $(document.body).on "click", "#delete-board-yes", ->
        $.ajax
            type: "POST"
            url: "/api/set/board/delete"
            data:
                id: home_board
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $("ul.boards li[data-board='"+home_board+"']").remove()
                $("#delete-board-modal").modal("hide")
                home_board = ""
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".category-edit", ->
        undefined

    $(document.body).on "click", ".category-delete", ->
        del_category = $(@).closest(".panel").attr("data-category")
        $("#delete-category-modal").modal("show")
        undefined

    $(document.body).on "click", "#delete-category-yes", ->
        $.ajax
            type: "POST"
            url: "/api/set/category/delete"
            data:
                id: del_category
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $("div.categories div.panel[data-category='"+del_category+"']").remove()
                $("#delete-category-modal").modal("hide")
                del_category = ""
            error: (jqXHR, textStatus, err) ->
                console.log err

        undefined

    $(document.body).on "click", "#delete-category-no", ->
        $("#delete-category-modal").modal("hide")
        undefined

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

    undefined
) jQuery
