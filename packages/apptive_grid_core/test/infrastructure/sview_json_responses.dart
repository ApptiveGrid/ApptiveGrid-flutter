const sviewPreviewsJson = '''[
  {
    "type": "spreadsheet",
    "id": "63d28a8a78d9ca55c2af8b45",
    "name": "Grid Ansicht",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45",
        "method": "get"
      }
    }
  },
  {
    "type": "kanban",
    "id": "63e4a68393cf49ae03b08f1d",
    "name": "Grid Ansicht 3",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d",
        "method": "get"
      }
    }
  },
  {
    "type": "calendar",
    "id": "63e4a68693cf49beccb08f23",
    "name": "Grid Ansicht 4",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23",
        "method": "get"
      }
    }
  },
  {
    "type": "map",
    "id": "63e4a68893cf4966e0b08f28",
    "name": "Grid Ansicht 5",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28",
        "method": "get"
      }
    }
  },
  {
    "type": "gallery",
    "id": "63e4a68893cf4966e0b08f15",
    "name": "Grid Ansicht 6",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f15",
        "method": "get"
      }
    }
  }
]''';

const kanbanSViewJson = '''{
   "slotProperties": {
      "63d28a8978d9ca3100af8b3f": {},
      "63e4a86993cf49fd11b08f2a": {
         "isKanbanState": true
      }
   },
   "fields": [
      {
         "key": null,
         "type": {
            "name": "string",
            "typeName": "string",
            "componentTypes": [
               "textfield"
            ]
         },
         "schema": {
            "type": "string"
         },
         "id": "63d28a8978d9ca3100af8b3f",
         "name": "name",
         "_links": {
            "patch": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "patch"
            },
            "query": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query",
               "method": "get"
            },
            "self": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "get"
            },
            "extractToGrid": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid",
               "method": "post"
            }
         }
      },
      {
         "key": null,
         "type": {
            "options": [
               "A"
            ],
            "componentTypes": [
               "selectBox",
               "selectList"
            ],
            "name": "enum",
            "typeName": "enum",
            "extended": false
         },
         "schema": {
            "type": "string",
            "enum": [
               "A"
            ]
         },
         "id": "63e4a86993cf49fd11b08f2a",
         "name": "New field",
         "_links": {
            "patch": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a",
               "method": "patch"
            },
            "query": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a/query",
               "method": "get"
            },
            "self": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a",
               "method": "get"
            },
            "extractToGrid": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a/extractToGrid",
               "method": "post"
            }
         }
      }
   ],
   "properties": {
      "version": 2
   },
   "type": "kanban",
   "id": "63e4a68393cf49ae03b08f1d",
   "name": "Grid Ansicht 3",
   "_links": {
      "addShare": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d/shares",
         "method": "post"
      },
      "entities": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/entities",
         "method": "get"
      },
      "shares": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d/shares",
         "method": "get"
      },
      "self": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d",
         "method": "get"
      },
      "grid": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b",
         "method": "get"
      },
      "remove": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d",
         "method": "delete"
      },
      "patch": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d",
         "method": "patch"
      }
   },
   "_embedded": {
      "shares": [],
      "schema": {
         "slots": {
            "63d28a8978d9ca3100af8b3f": {
               "position": 1,
               "type": {
                  "name": "string",
                  "typeName": "string",
                  "componentTypes": [
                     "textfield"
                  ]
               }
            },
            "63e4a86993cf49fd11b08f2a": {
               "position": 2,
               "type": {
                  "options": [
                     "A"
                  ],
                  "componentTypes": [
                     "selectBox",
                     "selectList"
                  ],
                  "name": "enum",
                  "typeName": "enum",
                  "extended": false
               }
            }
         }
      }
   }
}''';

const calendarSViewJson = '''{
   "slotProperties": {
      "63e4acde93cf492621b08f2e": {
         "isStartField": true
      },
      "63d28a8978d9ca3100af8b3f": {}
   },
   "properties": {
      "version": 2
   },
   "fields": [
      {
         "key": null,
         "type": {
            "name": "string",
            "typeName": "string",
            "componentTypes": [
               "textfield"
            ]
         },
         "schema": {
            "type": "string"
         },
         "id": "63d28a8978d9ca3100af8b3f",
         "name": "name",
         "_links": {
            "patch": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "patch"
            },
            "query": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query",
               "method": "get"
            },
            "self": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "get"
            },
            "extractToGrid": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid",
               "method": "post"
            }
         }
      },
      {
         "key": null,
         "type": {
            "name": "date-time",
            "typeName": "date-time",
            "componentTypes": [
               "datePicker"
            ]
         },
         "schema": {
            "type": "string",
            "format": "date-time"
         },
         "id": "63e4acde93cf492621b08f2e",
         "name": "Neues Feld 1",
         "_links": {
            "patch": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e",
               "method": "patch"
            },
            "query": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e/query",
               "method": "get"
            },
            "self": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e",
               "method": "get"
            },
            "extractToGrid": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e/extractToGrid",
               "method": "post"
            }
         }
      }
   ],
   "type": "calendar",
   "id": "63e4a68693cf49beccb08f23",
   "name": "Grid Ansicht 4",
   "_links": {
      "addShare": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23/shares",
         "method": "post"
      },
      "entities": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/entities",
         "method": "get"
      },
      "shares": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23/shares",
         "method": "get"
      },
      "self": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23",
         "method": "get"
      },
      "grid": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21",
         "method": "get"
      },
      "remove": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23",
         "method": "delete"
      },
      "patch": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23",
         "method": "patch"
      }
   },
   "_embedded": {
      "shares": [],
      "schema": {
         "slots": {
            "63d28a8978d9ca3100af8b3f": {
               "position": 1,
               "type": {
                  "name": "string",
                  "typeName": "string",
                  "componentTypes": [
                     "textfield"
                  ]
               }
            },
            "63e4acde93cf492621b08f2e": {
               "position": 2,
               "type": {
                  "name": "date-time",
                  "typeName": "date-time",
                  "componentTypes": [
                     "datePicker"
                  ]
               }
            }
         }
      }
   }
}''';

const mapSViewJson = '''{
   "slotProperties": {
      "63d28a8978d9ca3100af8b3f": {}
   },
   "fields": [
      {
         "key": null,
         "type": {
            "name": "string",
            "typeName": "string",
            "componentTypes": [
               "textfield"
            ]
         },
         "schema": {
            "type": "string"
         },
         "id": "63d28a8978d9ca3100af8b3f",
         "name": "name",
         "_links": {
            "patch": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "patch"
            },
            "query": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query",
               "method": "get"
            },
            "self": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "get"
            },
            "extractToGrid": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid",
               "method": "post"
            }
         }
      }
   ],
   "properties": {
      "zoomLevel": 14,
      "version": 1,
      "stateFieldId": "63e4ace493cf492621b08f32",
      "mapCenter": {
         "lng": 6.958303812540371,
         "lat": 50.941248064035904
      }
   },
   "type": "map",
   "id": "63e4a68893cf4966e0b08f28",
   "name": "Grid Ansicht 5",
   "_links": {
      "addShare": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28/shares",
         "method": "post"
      },
      "entities": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/entities",
         "method": "get"
      },
      "shares": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28/shares",
         "method": "get"
      },
      "self": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28",
         "method": "get"
      },
      "grid": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25",
         "method": "get"
      },
      "remove": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28",
         "method": "delete"
      },
      "patch": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28",
         "method": "patch"
      }
   },
   "_embedded": {
      "shares": [],
      "schema": {
         "slots": {
            "63d28a8978d9ca3100af8b3f": {
               "position": 1,
               "type": {
                  "name": "string",
                  "typeName": "string",
                  "componentTypes": [
                     "textfield"
                  ]
               }
            }
         }
      }
   }
}''';

const spreadsheetSViewJson = '''{
   "slotProperties": {
      "63d28a8978d9ca3100af8b3f": {}
   },
   "properties": {
      "version": 1
   },
   "fields": [
      {
         "key": null,
         "type": {
            "name": "string",
            "typeName": "string",
            "componentTypes": [
               "textfield"
            ]
         },
         "schema": {
            "type": "string"
         },
         "id": "63d28a8978d9ca3100af8b3f",
         "name": "name",
         "_links": {
            "patch": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "patch"
            },
            "query": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query",
               "method": "get"
            },
            "self": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f",
               "method": "get"
            },
            "extractToGrid": {
               "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid",
               "method": "post"
            }
         }
      }
   ],
   "type": "spreadsheet",
   "id": "63d28a8a78d9ca55c2af8b45",
   "name": "Grid Ansicht",
   "_links": {
      "addShare": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45/shares",
         "method": "post"
      },
      "entities": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/entities",
         "method": "get"
      },
      "shares": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45/shares",
         "method": "get"
      },
      "self": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45",
         "method": "get"
      },
      "grid": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43",
         "method": "get"
      },
      "remove": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45",
         "method": "delete"
      },
      "patch": {
         "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45",
         "method": "patch"
      }
   },
   "_embedded": {
      "shares": [],
      "schema": {
         "slots": {
            "63d28a8978d9ca3100af8b3f": {
               "position": 1,
               "type": {
                  "name": "string",
                  "typeName": "string",
                  "componentTypes": [
                     "textfield"
                  ]
               }
            }
         }
      }
   }
}''';

const gallerySViewJson = '''{
   "name": "Radio Test Ansicht 2",
   "id": "64197559dbe97e4cf0b3c4db",
   "slotProperties": {
      "639b061fd8165f7cb0ac2eac": {},
      "639b05e0d8165f7cb0ac2e9b": {},
      "639b0d42d8165f7301ac2eb7": {},
      "639b0614d8165f7cb0ac2ea9": {},
      "639b05fed8165f7cb0ac2ea4": {}
   },
   "fields": [
      {
         "name": "Default",
         "id": "639b05e0d8165f7cb0ac2e9b",
         "key": null,
         "schema": {
            "type": "string",
            "enum": [
               "A",
               "B",
               "C"
            ]
         },
         "type": {
            "options": [
               "A",
               "B",
               "C"
            ],
            "componentTypes": [
               "selectBox",
               "selectList"
            ],
            "name": "enum",
            "typeName": "enum",
            "extended": false
         },
         "_links": {
            "patch": {
               "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b",
               "method": "patch"
            },
            "query": {
               "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b/query",
               "method": "get"
            },
            "self": {
               "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b",
               "method": "get"
            },
            "extractToGrid": {
               "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b/extractToGrid",
               "method": "post"
            }
         }
      }
   ],
   "type": "gallery",
   "properties": {
      "version": 1
   },
   "_links": {
      "addShare": {
         "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db/shares",
         "method": "post"
      },
      "entities": {
         "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/entities",
         "method": "get"
      },
      "shares": {
         "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db/shares",
         "method": "get"
      },
      "self": {
         "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db",
         "method": "get"
      },
      "grid": {
         "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9",
         "method": "get"
      },
      "remove": {
         "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db",
         "method": "delete"
      },
      "patch": {
         "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db",
         "method": "patch"
      }
   },
   "_embedded": {
      "shares": [],
      "schema": {
         "slots": {
            "639b05e0d8165f7cb0ac2e9b": {
               "position": 1,
               "type": {
                  "options": [
                     "A",
                     "B",
                     "C"
                  ],
                  "componentTypes": [
                     "selectBox",
                     "selectList"
                  ],
                  "name": "enum",
                  "typeName": "enum",
                  "extended": false
               }
            }
         }
      }
   }
}''';

const depericatedSpreadsheetSViewJson = '''{
    "fieldProperties": {
        "77ugrb8mc6qy2ujwmw5bkimtd": {},
        "77ugrb980t1h5axdyfciya3ve": {},
        "77ugrbcauxmrn462bwf0lb9x0": {},
        "77ugrbda6nc67wd2sdlh0ilo9": {},
        "77ugrb8l4fr97f0dsj0rb75i4": {},
        "77ugrb9zrjy387co74jcivwji": {},
        "77ugrb9dqs6i0dgtzza81utk6": {},
        "77ugrb846piycj6ccpfhqr9rw": {},
        "77ugrbb8t8phr0hr9dy4zsnxf": {},
        "77ugrb6qspo6zswn9gvgqstmf": {},
        "77ugrb80dp7863w38j6ky4ekh": {},
        "77ugrbbum9ltqc53o4br3uslq": {},
        "77ugrb6h1d4fgt56xwrtw0eqg": {}
    },
    "id": "62ecd12bfa1b37d0aca1dbef",
    "name": "Test Ansicht",
    "properties": {},
    "type": "spreadsheet",
    "fields": [
        {
            "id": "77ugrb6h1d4fgt56xwrtw0eqg",
            "key": "willThisKey",
            "schema": {
                "type": "string"
            },
            "name": "Text",
            "type": {
                "name": "string",
                "typeName": "string",
                "componentTypes": [
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb8l4fr97f0dsj0rb75i4",
            "key": null,
            "schema": {
                "type": "integer"
            },
            "name": "Number",
            "type": {
                "name": "integer",
                "typeName": "integer",
                "componentTypes": [
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb846piycj6ccpfhqr9rw",
            "key": null,
            "schema": {
                "type": "string",
                "format": "date-time"
            },
            "name": "Date Time",
            "type": {
                "name": "date-time",
                "typeName": "date-time",
                "componentTypes": [
                    "datePicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrbb8t8phr0hr9dy4zsnxf",
            "key": null,
            "schema": {
                "type": "string",
                "format": "date"
            },
            "name": "Date",
            "type": {
                "name": "date",
                "typeName": "date",
                "componentTypes": [
                    "datePicker",
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb6qspo6zswn9gvgqstmf",
            "key": null,
            "schema": {
                "type": "boolean"
            },
            "name": "Checkmark",
            "type": {
                "name": "boolean",
                "typeName": "boolean",
                "componentTypes": [
                    "checkbox"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb8mc6qy2ujwmw5bkimtd",
            "key": null,
            "schema": {
                "type": "string",
                "enum": [
                    "A",
                    "B"
                ]
            },
            "name": "Single Select",
            "type": {
                "options": [
                    "A",
                    "B"
                ],
                "componentTypes": [
                    "selectBox",
                    "selectList"
                ],
                "name": "enum",
                "typeName": "enum",
                "extended": false
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb9dqs6i0dgtzza81utk6",
            "key": null,
            "schema": {
                "type": "array",
                "items": {
                    "type": "string",
                    "enum": [
                        "A",
                        "B"
                    ]
                }
            },
            "name": "Multiselect",
            "type": {
                "name": "enumcollection",
                "typeName": "enumcollection",
                "options": [
                    "A",
                    "B"
                ],
                "componentTypes": [
                    "multiSelectDropdown",
                    "multiSelectList"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrbbum9ltqc53o4br3uslq",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "displayValue": {
                        "type": "string"
                    },
                    "uri": {
                        "type": "string"
                    }
                },
                "required": [
                    "uri"
                ],
                "objectType": "entityreference",
                "gridUri": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a780d706edbdc3964570"
            },
            "name": "Cross Ref",
            "type": {
                "name": "reference",
                "typeName": "reference",
                "componentTypes": [
                    "entitySelect"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbbum9ltqc53o4br3uslq",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbbum9ltqc53o4br3uslq/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbbum9ltqc53o4br3uslq",
                    "method": "get"
                }
            }
        },
        {
            "id": "77ugrb980t1h5axdyfciya3ve",
            "key": null,
            "schema": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "displayValue": {
                            "type": "string"
                        },
                        "uri": {
                            "type": "string"
                        }
                    },
                    "required": [
                        "uri"
                    ],
                    "objectType": "entityreference",
                    "gridUri": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a780d706edbdc3964570"
                }
            },
            "name": "Multi Cross Ref",
            "type": {
                "name": "references",
                "typeName": "references",
                "componentTypes": [
                    "multiSelectDropdown"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb980t1h5axdyfciya3ve",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb980t1h5axdyfciya3ve/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb980t1h5axdyfciya3ve",
                    "method": "get"
                }
            }
        },
        {
            "id": "77ugrb9zrjy387co74jcivwji",
            "key": null,
            "schema": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "smallThumbnail": {
                            "type": "string"
                        },
                        "url": {
                            "type": "string",
                            "format": "string"
                        },
                        "largeThumbnail": {
                            "type": "string"
                        },
                        "name": {
                            "type": "string",
                            "format": "string"
                        },
                        "type": {
                            "type": "string",
                            "format": "string"
                        }
                    },
                    "required": [
                        "url",
                        "type"
                    ],
                    "objectType": "attachment"
                }
            },
            "name": "Attachment",
            "type": {
                "name": "attachments",
                "typeName": "attachments",
                "componentTypes": [
                    "filePicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrbcauxmrn462bwf0lb9x0",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "lat": {
                        "type": "number",
                        "format": "double"
                    },
                    "lon": {
                        "type": "number",
                        "format": "double"
                    }
                },
                "required": [
                    "lat",
                    "lon"
                ],
                "objectType": "geolocation"
            },
            "name": "Geolocation",
            "type": {
                "name": "geolocation",
                "typeName": "geolocation",
                "componentTypes": [
                    "locationPicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb80dp7863w38j6ky4ekh",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "displayValue": {
                        "type": "string",
                        "format": "string"
                    },
                    "id": {
                        "type": "string",
                        "format": "string"
                    },
                    "type": {
                        "type": "string",
                        "format": "string"
                    },
                    "name": {
                        "type": "string",
                        "format": "string"
                    }
                },
                "objectType": "userReference"
            },
            "name": "Created by",
            "type": {
                "name": "createdby",
                "typeName": "createdby",
                "componentTypes": [
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb80dp7863w38j6ky4ekh",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb80dp7863w38j6ky4ekh/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb80dp7863w38j6ky4ekh",
                    "method": "get"
                }
            }
        },
        {
            "id": "645cbea7ed1be1f8fcb7c7af",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "smallThumbnail": {
                        "type": "string"
                    },
                    "url": {
                        "type": "string",
                        "format": "string"
                    },
                    "largeThumbnail": {
                        "type": "string"
                    },
                    "name": {
                        "type": "string",
                        "format": "string"
                    },
                    "type": {
                        "type": "string",
                        "format": "string"
                    }
                },
                "required": [
                    "url",
                    "type"
                ],
                "objectType": "attachment"
            },
            "name": "Neues Feld 1",
            "type": {
                "name": "signature",
                "typeName": "signature",
                "componentTypes": [
                    "filePicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af/extractToGrid",
                    "method": "post"
                }
            }
        }
    ],
    "_links": {
        "addShare": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a76ad706edeab79639f7/sviews/62ecd12bfa1b37d0aca1dbef/shares",
            "method": "post"
        },
        "entities": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a76ad706edeab79639f7/entities",
            "method": "get"
        },
        "shares": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a76ad706edeab79639f7/sviews/62ecd12bfa1b37d0aca1dbef/shares",
            "method": "get"
        },
        "self": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a76ad706edeab79639f7/sviews/62ecd12bfa1b37d0aca1dbef",
            "method": "get"
        },
        "grid": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a76ad706edeab79639f7",
            "method": "get"
        },
        "remove": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a76ad706edeab79639f7/sviews/62ecd12bfa1b37d0aca1dbef",
            "method": "delete"
        },
        "patch": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a76ad706edeab79639f7/sviews/62ecd12bfa1b37d0aca1dbef",
            "method": "patch"
        }
    },
    "_embedded": {
        "shares": []
    }
}''';

const deprecatedCanbanSViewJson = '''{
    "fieldProperties": {
        "77ugrb8mc6qy2ujwmw5bkimtd": {
            "isKanbanState": true
        },
        "77ugrb980t1h5axdyfciya3ve": {},
        "77ugrbcauxmrn462bwf0lb9x0": {},
        "77ugrbda6nc67wd2sdlh0ilo9": {},
        "77ugrb8l4fr97f0dsj0rb75i4": {},
        "645cbea7ed1be1f8fcb7c7af": {},
        "77ugrb9zrjy387co74jcivwji": {},
        "77ugrb9dqs6i0dgtzza81utk6": {},
        "77ugrb846piycj6ccpfhqr9rw": {},
        "77ugrbb8t8phr0hr9dy4zsnxf": {},
        "77ugrb6qspo6zswn9gvgqstmf": {},
        "77ugrb80dp7863w38j6ky4ekh": {},
        "77ugrbbum9ltqc53o4br3uslq": {},
        "77ugrb6h1d4fgt56xwrtw0eqg": {}
    },
    "id": "65362de7bba0923aabc4bf93",
    "name": "Test Ansicht 2",
    "properties": {
        "version": 2
    },
    "type": "kanban",
    "fields": [
        {
            "id": "77ugrb6h1d4fgt56xwrtw0eqg",
            "key": "willThisKey",
            "schema": {
                "type": "string"
            },
            "name": "Text",
            "type": {
                "name": "string",
                "typeName": "string",
                "componentTypes": [
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6h1d4fgt56xwrtw0eqg/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb8l4fr97f0dsj0rb75i4",
            "key": null,
            "schema": {
                "type": "integer"
            },
            "name": "Number",
            "type": {
                "name": "integer",
                "typeName": "integer",
                "componentTypes": [
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8l4fr97f0dsj0rb75i4/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrbda6nc67wd2sdlh0ilo9",
            "key": null,
            "schema": {
                "type": "number",
                "format": "float"
            },
            "name": "Float",
            "type": {
                "name": "decimal",
                "typeName": "decimal",
                "componentTypes": [
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbda6nc67wd2sdlh0ilo9",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbda6nc67wd2sdlh0ilo9/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbda6nc67wd2sdlh0ilo9",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbda6nc67wd2sdlh0ilo9/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb846piycj6ccpfhqr9rw",
            "key": null,
            "schema": {
                "type": "string",
                "format": "date-time"
            },
            "name": "Date Time",
            "type": {
                "name": "date-time",
                "typeName": "date-time",
                "componentTypes": [
                    "datePicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb846piycj6ccpfhqr9rw/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrbb8t8phr0hr9dy4zsnxf",
            "key": null,
            "schema": {
                "type": "string",
                "format": "date"
            },
            "name": "Date",
            "type": {
                "name": "date",
                "typeName": "date",
                "componentTypes": [
                    "datePicker",
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbb8t8phr0hr9dy4zsnxf/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb6qspo6zswn9gvgqstmf",
            "key": null,
            "schema": {
                "type": "boolean"
            },
            "name": "Checkmark",
            "type": {
                "name": "boolean",
                "typeName": "boolean",
                "componentTypes": [
                    "checkbox"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb6qspo6zswn9gvgqstmf/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb8mc6qy2ujwmw5bkimtd",
            "key": null,
            "schema": {
                "type": "string",
                "enum": [
                    "A",
                    "B"
                ]
            },
            "name": "Single Select",
            "type": {
                "options": [
                    "A",
                    "B"
                ],
                "componentTypes": [
                    "selectBox",
                    "selectList"
                ],
                "name": "enum",
                "typeName": "enum",
                "extended": false
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb8mc6qy2ujwmw5bkimtd/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb9dqs6i0dgtzza81utk6",
            "key": null,
            "schema": {
                "type": "array",
                "items": {
                    "type": "string",
                    "enum": [
                        "A",
                        "B"
                    ]
                }
            },
            "name": "Multiselect",
            "type": {
                "name": "enumcollection",
                "typeName": "enumcollection",
                "options": [
                    "A",
                    "B"
                ],
                "componentTypes": [
                    "multiSelectDropdown",
                    "multiSelectList"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9dqs6i0dgtzza81utk6/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrbbum9ltqc53o4br3uslq",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "displayValue": {
                        "type": "string"
                    },
                    "uri": {
                        "type": "string"
                    }
                },
                "required": [
                    "uri"
                ],
                "objectType": "entityreference",
                "gridUri": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a780d706edbdc3964570"
            },
            "name": "Cross Ref",
            "type": {
                "name": "reference",
                "typeName": "reference",
                "componentTypes": [
                    "entitySelect"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbbum9ltqc53o4br3uslq",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbbum9ltqc53o4br3uslq/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbbum9ltqc53o4br3uslq",
                    "method": "get"
                }
            }
        },
        {
            "id": "77ugrb980t1h5axdyfciya3ve",
            "key": null,
            "schema": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "displayValue": {
                            "type": "string"
                        },
                        "uri": {
                            "type": "string"
                        }
                    },
                    "required": [
                        "uri"
                    ],
                    "objectType": "entityreference",
                    "gridUri": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a780d706edbdc3964570"
                }
            },
            "name": "Multi Cross Ref",
            "type": {
                "name": "references",
                "typeName": "references",
                "componentTypes": [
                    "multiSelectDropdown"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb980t1h5axdyfciya3ve",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb980t1h5axdyfciya3ve/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb980t1h5axdyfciya3ve",
                    "method": "get"
                }
            }
        },
        {
            "id": "77ugrb9zrjy387co74jcivwji",
            "key": null,
            "schema": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "smallThumbnail": {
                            "type": "string"
                        },
                        "url": {
                            "type": "string",
                            "format": "string"
                        },
                        "largeThumbnail": {
                            "type": "string"
                        },
                        "name": {
                            "type": "string",
                            "format": "string"
                        },
                        "type": {
                            "type": "string",
                            "format": "string"
                        }
                    },
                    "required": [
                        "url",
                        "type"
                    ],
                    "objectType": "attachment"
                }
            },
            "name": "Attachment",
            "type": {
                "name": "attachments",
                "typeName": "attachments",
                "componentTypes": [
                    "filePicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb9zrjy387co74jcivwji/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrbcauxmrn462bwf0lb9x0",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "lat": {
                        "type": "number",
                        "format": "double"
                    },
                    "lon": {
                        "type": "number",
                        "format": "double"
                    }
                },
                "required": [
                    "lat",
                    "lon"
                ],
                "objectType": "geolocation"
            },
            "name": "Geolocation",
            "type": {
                "name": "geolocation",
                "typeName": "geolocation",
                "componentTypes": [
                    "locationPicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrbcauxmrn462bwf0lb9x0/extractToGrid",
                    "method": "post"
                }
            }
        },
        {
            "id": "77ugrb80dp7863w38j6ky4ekh",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "displayValue": {
                        "type": "string",
                        "format": "string"
                    },
                    "id": {
                        "type": "string",
                        "format": "string"
                    },
                    "type": {
                        "type": "string",
                        "format": "string"
                    },
                    "name": {
                        "type": "string",
                        "format": "string"
                    }
                },
                "objectType": "userReference"
            },
            "name": "Created by",
            "type": {
                "name": "createdby",
                "typeName": "createdby",
                "componentTypes": [
                    "textfield"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb80dp7863w38j6ky4ekh",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb80dp7863w38j6ky4ekh/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/77ugrb80dp7863w38j6ky4ekh",
                    "method": "get"
                }
            }
        },
        {
            "id": "645cbea7ed1be1f8fcb7c7af",
            "key": null,
            "schema": {
                "type": "object",
                "properties": {
                    "smallThumbnail": {
                        "type": "string"
                    },
                    "url": {
                        "type": "string",
                        "format": "string"
                    },
                    "largeThumbnail": {
                        "type": "string"
                    },
                    "name": {
                        "type": "string",
                        "format": "string"
                    },
                    "type": {
                        "type": "string",
                        "format": "string"
                    }
                },
                "required": [
                    "url",
                    "type"
                ],
                "objectType": "attachment"
            },
            "name": "Neues Feld 1",
            "type": {
                "name": "signature",
                "typeName": "signature",
                "componentTypes": [
                    "filePicker"
                ]
            },
            "_links": {
                "patch": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af",
                    "method": "patch"
                },
                "query": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af/query",
                    "method": "get"
                },
                "self": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af",
                    "method": "get"
                },
                "extractToGrid": {
                    "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/6229a769d706edeab79639f4/fields/645cbea7ed1be1f8fcb7c7af/extractToGrid",
                    "method": "post"
                }
            }
        }
    ],
    "_links": {
        "addShare": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/65362de7bba09207adc4bf91/sviews/65362de7bba0923aabc4bf93/shares",
            "method": "post"
        },
        "entities": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/65362de7bba09207adc4bf91/entities",
            "method": "get"
        },
        "shares": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/65362de7bba09207adc4bf91/sviews/65362de7bba0923aabc4bf93/shares",
            "method": "get"
        },
        "self": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/65362de7bba09207adc4bf91/sviews/65362de7bba0923aabc4bf93",
            "method": "get"
        },
        "grid": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/65362de7bba09207adc4bf91",
            "method": "get"
        },
        "remove": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/65362de7bba09207adc4bf91/sviews/65362de7bba0923aabc4bf93",
            "method": "delete"
        },
        "patch": {
            "href": "/api/users/614c5440b50f51e3ea8a2a50/spaces/6229a766d706edeab79639f1/grids/65362de7bba09207adc4bf91/sviews/65362de7bba0923aabc4bf93",
            "method": "patch"
        }
    },
    "_embedded": {
        "shares": []
    }
}''';
