import glob, os

import streamlit as st

from datatypes import gnice_prompt ,webui_strings as ui_str
from forms import Prompt_Editor_Form, Clickable_List_Form


class Prompt_Editor_Tabs():
    def __init__(self, title: str):
        self.title: str = title
        self.tab_context: any = None
        self.name_to_file: dict[str, str] = {}

def generate_prompt_editors():
    tabs_dict:dict[str, Prompt_Editor_Tabs] = {}

    for full_path in glob.iglob(f'{ui_str.path_prompts}/**', recursive=True):

        if not os.path.isfile(full_path):
            continue
        if not full_path.endswith(".prompt"):
            continue

        prompt_file = full_path[len(ui_str.path_prompts)+1:-7]

        # stupid os.pathsep returning ; instead of \ in windows
        sub_dir = ""
        if (prompt_file.rfind("/") != -1):
            sub_dir = prompt_file[:prompt_file.find("/")]
        elif (prompt_file.rfind("\\") != -1):
            sub_dir = prompt_file[:prompt_file.find("\\")]
        else:
            sub_dir = ".root"

        if sub_dir not in tabs_dict.keys():
            tabs_dict[sub_dir] = Prompt_Editor_Tabs(title=sub_dir)
        tabs_dict[sub_dir].name_to_file[gnice_prompt(full_path)] = full_path

    #create tabs and associate them with the dict    
    sorted_tabs_list = sorted(tabs_dict.keys())
    _tabs = st.tabs(sorted_tabs_list)
    for tl_item, tl_value in enumerate(sorted_tabs_list):
        tabs_dict[tl_value].tab_context = _tabs[tl_item]

    for tab_val in tabs_dict.values():
        with tab_val.tab_context:
            col_cl, col_edit = st.columns([1, 3])
            with col_cl:
                click_sel = Clickable_List_Form(list(tab_val.name_to_file.keys()))
            with col_edit:
                if click_sel.selection not in tab_val.name_to_file.keys():
                    continue
                st.write(f"**{click_sel.selection}**")
                Prompt_Editor_Form(
                    name_nice = click_sel.selection, 
                    filename = tab_val.name_to_file[click_sel.selection])