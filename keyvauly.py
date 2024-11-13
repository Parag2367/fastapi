@router.post('/create_kv', tags=['dataops-automation'])
def create_keyvault(params: schemas.create_kv, response: Response):

    # define bicep variables to be used with KV process
    # ba-n-zeaus-cgdst-rg    ba-n-zeaus-cgdst-kv   baneausstgcgdstdev
    try:
        params = params.dict()
        pre=params['rg_name'][0:11].strip().lower()
        suf=params['rg_name'][11:params['rg_name'].strip().lower().find('-rg')].strip().lower() + '-kv'
    
        if params['kv_name'] == None:
            params['kv_name'] = kv
        else:
            params['kv_name'] = pre + suf

        requestor_aa_id = params['requestor_aa_id']

        unique_id = str(uuid.uuid4())


        file_name_json = params['kv_name']+".json"
        file_name_trigger = "newkvfile.txt"

        file_content_json =json.dumps({"resourceGroupName": params['rg_name'].strip().lower(),
                            "aaLocation": params['aa_location'].strip(),"storageSkuName": params['storage_sku'].strip(),
                            "keyVaultName": params['kv_name']})


        # define trigger
        file_content_trigger = f"""\
filename: {file_name_json}
#API call_id {unique_id}
#SUBMITTER-AAID {requestor_aa_id}
"""

    except Exception as err:
        err_msg = "Error #01 >> define bicep variables to be used with KV process: " + \
            str(err)
        print("====="+str(err_msg)+"======")
        logging.error(err_msg)
        raise HTTPException(status_code=500, detail=err_msg)

    try:
        env_filename = "create_kv"
        now = datetime.now().astimezone(pytz.timezone('US/Central'))
        commit_msg = f"| {suf.upper()} | {params['kv_name']} | {now.strftime('%Y-%m-%d')} | {now.strftime('%H:%M:%S')} | Provisioning KV | requestor {requestor_aa_id}"

        committed = []
        committed.append(
            git.push_to_github_wrapper(requestor_aa_id=requestor_aa_id, out_filename=file_name_json, out_content=file_content_json,
                                       env_filename=env_filename, commit_msg=commit_msg, env_testing=False)
        )

        committed.append(
            git.push_to_github_wrapper(requestor_aa_id=requestor_aa_id, out_filename=file_name_trigger, out_content=file_content_trigger,
                                       env_filename=env_filename, commit_msg=commit_msg, env_testing=False)
        )

        return params

    except Exception as err:
        err_msg = "Error #99 >> Error writing file on github repo: " + \
            str(err)
        print("====="+str(err_msg)+"======")
        logging.error(err_msg)
        raise HTTPException(status_code=500, detail=err_msg)