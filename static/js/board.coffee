(($) ->
    component_stash = {}
    board_delete = ""
    board_edit = ""

    $(document.body).on "click", "a.new-board", ->
        $("#new-board-modal-title").val ""
        undefined

    $(document.body).on "click", "#new-board-modal-submit", ->
        component = 0
        if "boarditem" not of component_stash
            component = 1
        title = $("#new-board-modal-title").val()
        $("#new-board-modal").modal "hide"
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
                $(".boards").eq(0).append board
                $("#new-board-modal").modal "hide"
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".board-link", ->
        window.location.href = $(@).attr "data-href"
        undefined

    $(document.body).on "click", ".board-edit", ->
        board_edit = $(@).attr "data-id"
        $("#edit-board-modal-title").val($(@).closest(".btn-group").find(".board-link").eq(0).text())
        $("#edit-board-modal").modal "show"
        undefined

    $(document.body).on "click", "#edit-board-modal-submit", ->
        title = $("#edit-board-modal-title").val()
        $.ajax
            type: "POST"
            url: "/api/set/board/update"
            data:
                id: board_edit
                title: title
            success: (data) ->
                console.log data
                if data.code != 200
                    console.log "ERROR: "+data.code
                $("ul.boards li[data-board='"+board_edit+"'] .btn-group .board-link").text title
                $("#edit-board-modal").modal "hide"
                board_edit = ""
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".board-delete", ->
        board_delete = $(@).attr "data-id"
        $("#delete-board-modal").modal "show"
        undefined

    $(document.body).on "click", "#delete-board-no", ->
        $("#delete-board-modal").modal "hide"
        undefined

    $(document.body).on "click", "#delete-board-yes", ->
        $.ajax
            type: "POST"
            url: "/api/set/board/delete"
            data:
                id: board_delete
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $("ul.boards li[data-board='"+board_delete+"']").remove()
                $("#delete-board-modal").modal "hide"
                board_delete = ""
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined
) jQuery
