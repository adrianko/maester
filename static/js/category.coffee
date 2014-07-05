(($) ->
    component_stash = {}
    del_category = ""
    edit_category = ""

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
                $("#new-category-modal").modal "hide"
                window.taskSortable()
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".category-edit", ->
        edit_category = $(@).closest(".panel").attr "data-category"
        $("#edit-category-modal-title").val($(@).closest(".panel-heading").children(".panel-title").text())
        $("#edit-category-modal").modal("show")
        undefined

    $(document.body).on "click", "#edit-category-modal-submit", ->
        title = $("#edit-category-modal-title").val()
        $.ajax
            type: "POST"
            url: "/api/set/category/update"
            data:
                id: edit_category
                title: title
            success: (data) ->
                console.log data
                if data.code != 200
                    console.log "ERROR: "+data.code
                $(".panel[data-category='"+edit_category +"'] .panel-heading .panel-title").text title
                $("#edit-category-modal").modal "hide"
                edit_category = ""
            error: (jqXHR, textStatus, err) ->
                console.log err


        undefined

    $(document.body).on "click", ".category-delete", ->
        del_category = $(@).closest(".panel").attr "data-category"
        $("#delete-category-modal").modal "show"
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
                $("#delete-category-modal").modal "hide"
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
            console.log $(".categories").eq(0).attr "data-board"
            $.ajax
                type: "POST"
                url: "/api/set/category/order"
                data:
                    id: $(".categories").eq(0).attr "data-board"
                    order: JSON.stringify ($(c).attr("data-category") for c in $("div.categories").find(".category"))
                success: (data)->
                    if data.code != 200
                        console.log "ERROR: "+data.code
                    console.log data
                error: (jqXHR, textStatus, err) ->
                    console.log err
    ).disableSelection()
) jQuery
