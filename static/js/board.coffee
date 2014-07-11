(($) ->
    component_stash = {}
    board_delete = ""
    board_edit = ""

    $(document.body).on "click", ".new-board", ->
        $("#new-board-modal-title").val ""
        undefined

    $(document.body).on "click", "#new-board-modal-submit", ->
        component = 0
        if "boarditem" not of component_stash
            component = 1
        title = $("#new-board-modal-title").val()
        description = $("#new-board-modal-desc").val()
        background = $("#new-board-modal-bg").val()
        $("#new-board-modal").modal "hide"
        $.ajax
            type: "POST"
            url: "/api/set/board/new"
            data:
                component: component
                title: title
                description: description
                background: background
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                if component is 1
                    component_stash.boarditem = data.data.components
                board = component_stash.boarditem
                board = board.split "{{ b.id }}"
                board = board.join data.data.id
                board = board.replace "{{ b.title }}", title
                board = board.replace "{{ b.description }}", description
                board = board.split "{{ b.background }}"
                board = board.join background
                $(".boards").eq(0).append board
                $("#new-board-modal").modal "hide"
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".board-link", ->
        window.location.href = $(@).attr "data-href"
        undefined

    $(document.body).on "click", ".board-dd", (e) ->
        e.preventDefault()
        e.stopPropagation()
        $(@).dropdown("toggle")
        undefined

    $(document.body).on "click", ".board-edit", (e) ->
        e.preventDefault()
        e.stopPropagation()
        board_edit = $(@).attr "data-id"
        $("#edit-board-modal-title").val($(@).closest(".board-item").find(".board-title").text())
        $("#edit-board-modal-desc").val($(@).closest(".board-item").find(".board-description").text())
        $("#edit-board-modal-bg").val($(@).closest(".board-item").attr "data-background")
        $("#edit-board-modal").modal "show"
        undefined

    $(document.body).on "click", "#edit-board-modal-submit", ->
        title = $("#edit-board-modal-title").val()
        description = $("#edit-board-modal-desc").val()
        background = $("#edit-board-modal-bg").val()
        $.ajax
            type: "POST"
            url: "/api/set/board/update"
            data:
                id: board_edit
                title: title
                description: description
                background: background
            success: (data) ->
                if data.code != 200
                    console.log "ERROR: "+data.code
                $(".boards .board-item[data-board='"+board_edit+"'] .board-title").text title
                $(".boards .board-item[data-board='"+board_edit+"'] .board-description").text description
                $(".boards .board-item[data-board='"+board_edit+"']").attr "data-background", background
                $(".boards .board-item[data-board='"+board_edit+"']").css "background", "#"+background
                $("#edit-board-modal").modal "hide"
                board_edit = ""
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined

    $(document.body).on "click", ".board-delete", (e) ->
        e.preventDefault()
        e.stopPropagation()
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
                $(".boards .board-item[data-board='"+board_delete+"']").remove()
                $("#delete-board-modal").modal "hide"
                board_delete = ""
            error: (jqXHR, textStatus, err) ->
                console.log err
        undefined
) jQuery
