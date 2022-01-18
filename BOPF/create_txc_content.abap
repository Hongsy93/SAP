METHOD create_txc_content.
  DATA:
    lv_key               TYPE /bobf/conf_key,
    lv_txc_text_key      TYPE /bobf/conf_key,
    lv_txc_text_node     TYPE /bobf/conf_key,
    lv_txc_content_node  TYPE /bobf/conf_key,
    lv_txc_content_assoc TYPE /bobf/conf_key.
  DATA:
  ls_txc_content TYPE /bobf/s_txc_con_k.
  IF iv_key IS INITIAL OR iv_txc_text_key IS INITIAL.
    RETURN.
  ELSE.
    lv_key = iv_key.
    lv_txc_text_key = iv_txc_text_key.
  ENDIF.
  DATA(lo_conf_trq) =
  /bobf/cl_frw_factory=>get_configuration( iv_bo_key = /scmtms/if_trq_c=>sc_bo_key ).
  " Get key
  lo_conf_trq->get_content_key_mapping(
  EXPORTING
  iv_content_cat = /bobf/if_conf_c=>sc_content_nod
  iv_do_content_key = /bobf/if_txc_c=>sc_node-text
  iv_do_root_node_key = /scmtms/if_trq_c=>sc_node-textcollection
  RECEIVING
  ev_content_key = lv_txc_text_node
  ).
  lo_conf_trq->get_content_key_mapping(
  EXPORTING
  iv_content_cat = /bobf/if_conf_c=>sc_content_nod
  iv_do_content_key = /bobf/if_txc_c=>sc_node-text_content
  iv_do_root_node_key = /scmtms/if_trq_c=>sc_node-textcollection
  RECEIVING
  ev_content_key = lv_txc_content_node
  ).
  lo_conf_trq->get_content_key_mapping(
  EXPORTING
  iv_content_cat = /bobf/if_conf_c=>sc_content_ass
  iv_do_content_key = /bobf/if_txc_c=>sc_association-text-text_content
  iv_do_root_node_key = /scmtms/if_trq_c=>sc_node-textcollection
  RECEIVING
  ev_content_key = lv_txc_content_assoc
  ).
  CLEAR ls_txc_content.
  ls_txc_content-key = /bobf/cl_frw_factory=>get_new_key( ).
  ls_txc_content-parent_key = lv_txc_text_key.
  ls_txc_content-root_key = lv_key.
  ls_txc_content-text = ms_data-remark.
  /scmtms/cl_mod_helper=>mod_create_single(
  EXPORTING
  is_data = ls_txc_content
  iv_node = lv_txc_content_node
  iv_source_node = lv_txc_text_node
  iv_association = lv_txc_content_assoc
  CHANGING
  ct_mod = ct_mod
  ).
ENDMETHOD.
