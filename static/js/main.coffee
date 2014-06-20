(($) ->
    component_stash = {}
    modal = ""

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
                createTask()
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(".task-list").sortable(
       axis: "y",
       containment: "parent",
       placeholder: "placeholder"
       stop: (e, ui) ->
           $.ajax
               type: "POST"
               url: "/api/set/task/order"
               data:
                   order: JSON.stringify ($(t).attr("data-id") for t in $(@).parent().find(".task"))
               success: (data) ->
                   if data.code != 200
                       console.log "Error: "+data.code
               error: (jqXHR, textStatus, err) ->
                   console.log err
    ).disableSelection()

    createTask = () ->
        $("div.panel[data-category='"+modal+"'] .panel-body .task-list")
            .append(component_stash.task.replace "{{ title }}", $("#new-task-modal-title").val())
        $("#new-task-modal").modal("hide")
        null

    undefined
) jQuery
