(($) ->
    component_stash = {}
    category_delete = ""
    category_edit = ""
    category_action = ""

    categoryWidth = () ->
        $(".categories").width(($(".panel").length)*320)
        undefined

    categoryColour = () ->
        for x in $(".panel")
            if $(x).find(".panel-heading").find(".panel-title").text().toLowerCase().indexOf("emergency") > -1
                $(x).removeClass "panel-default"
                $(x).addClass "panel-danger"
        undefined

    modalLabels = () ->
        if category_action == "edit"
            $("#category-modal .modal-dialog .modal-content .modal-header .modal-title").text "Edit category"
            $("#category-modal-submit").text "Update"
        else
            $("#category-modal .modal-dialog .modal-content .modal-header .modal-title").text "Add category"
            $("#category-modal-submit").text "Add"
        undefined

    categoryWidth()
    categoryColour()

    $(document.body).on "click", "a.new-category", ->
        category_action = "new"
        modalLabels()
        $("#category-modal-title").val ""
        $("#category-modal").modal "show"
        undefined

    $(document.body).on "click", "#category-modal-submit", ->
        title = $("#category-modal-title").val()
        if category_action == "new"
            component = 0
            if "category" not of component_stash
                component = 1
            $.ajax
                type: "POST"
                url: "/api/set/category/new"
                data:
                    component: component
                    id: $(".new-category:first").attr "data-board"
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
                    $("div.categories").append category
                    $("#category-modal").modal "hide"
                    categoryWidth()
                    categoryColour()
                    window.taskSortable()
                error: (jqXHR, textStatus, err) ->
                    console.log err
        else
            $.ajax
                type: "POST"
                url: "/api/set/category/update"
                data:
                    id: category_edit
                    title: title
                success: (data) ->
                    if data.code != 200
                        console.log "ERROR: "+data.code
                    $(".panel[data-category='"+category_edit+"'] .panel-heading .panel-title").text title
                    $("#category-modal").modal "hide"
                    category_edit = ""
                    categoryColour()
                error: (jqXHR, textStatus, err) ->
                    console.log err
        undefined

    $(document.body).on "click", ".category-edit", ->
        category_edit = $(@).closest(".panel").attr "data-category"
        category_action = "edit"
        modalLabels()
        $("#category-modal-title").val($(@).closest(".panel-heading").children(".panel-title").text())
        $("#category-modal").modal "show"
        undefined

    $(document.body).on "click", ".category-delete", ->
        category_delete = $(@).closest(".panel").attr "data-category"
        $("#delete-category-modal").modal "show"
        undefined

    $(document.body).on "click", "#delete-category-yes", ->
        $.ajax
            type: "POST"
            url: "/api/set/category/delete"
            data:
                id: category_delete
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $("div.categories div.panel[data-category='"+category_delete+"']").remove()
                $("#delete-category-modal").modal "hide"
                categoryWidth()
                category_delete = ""
            error: (jqXHR, textStatus, err) ->
                console.log err

        undefined

    $(document.body).on "click", "#delete-category-no", ->
        $("#delete-category-modal").modal "hide"
        undefined

    $(".categories").sortable(
        handle: ".reorder"
        placeholder: "placeholder-category"
        stop: (e, ui) ->
            $.ajax
                type: "POST"
                url: "/api/set/category/order"
                data:
                    id: $(".categories").eq(0).attr "data-board"
                    order: JSON.stringify ($(c).attr "data-category" for c in $("div.categories").find ".category")
                success: (data)->
                    if data.code != 200
                        console.log "ERROR: "+data.code
                error: (jqXHR, textStatus, err) ->
                    console.log err
    ).disableSelection()

) jQuery
