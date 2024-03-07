using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    class CurvedWorldMaterialDuplicateEditorWindow : EditorWindow
    {
        static public CurvedWorldMaterialDuplicateEditorWindow window;


        public delegate void DataChanged(string subFolderName, string prefix, string suffix, object obj);
        static DataChanged callback;


        string subFolderName;
        string prefix;
        string suffix;


        static object objMaterial;
        static Vector2 windowResolution = new Vector2(340, 158);



        static public void ShowWindow(Vector2 position, DataChanged method, object obj)
        {
            if (window != null)
            {
                window.Close();
                window = null;
            }


            window = (CurvedWorldMaterialDuplicateEditorWindow)CurvedWorldMaterialDuplicateEditorWindow.CreateInstance(typeof(CurvedWorldMaterialDuplicateEditorWindow));
            window.titleContent = new GUIContent("Duplicate Material");

            callback = method;
            objMaterial = obj;


            window.minSize = windowResolution;
            window.maxSize = windowResolution;

            window.ShowUtility();
            window.position = new Rect(position.x, position.y, windowResolution.x, windowResolution.y);
        }


        void OnLostFocus()
        {
            if (window != null)
            {
                window.Close();
                window = null;
            }
        }

        void OnGUI()
        {
            if (callback == null ||
               (window != null && this != window))
                this.Close();


            subFolderName = subFolderName == null ? string.Empty : subFolderName;
            prefix = prefix == null ? string.Empty : prefix;
            suffix = suffix == null ? string.Empty : suffix;


            using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
            {
                using (new EditorGUIHelper.EditorGUIUtilityLabelWidth(110))
                {
                    using (new EditorGUIHelper.GUIBackgroundColor(EditorUtilities.ContainsInvalidFileNameCharacters(subFolderName.Trim()) ? Color.red : Color.white))
                    {
                        subFolderName = EditorGUILayout.TextField("Subfolder Name", subFolderName);
                    }

                    GUILayout.Space(5);
                    EditorGUILayout.HelpBox("Leave 'Subfolder Name' field empty to create material duplicate in the same folder. In this case file prefix/suffix are required.", MessageType.Info);
                    GUILayout.Space(5);

                    if (prefix == null) prefix = string.Empty;
                    if (suffix == null) suffix = string.Empty;

                    Color backGroundColor = Color.white;
                    if (string.IsNullOrEmpty(subFolderName.Trim()))
                    {
                        if (string.IsNullOrEmpty((prefix + suffix).Trim()) || EditorUtilities.ContainsInvalidFileNameCharacters(prefix))
                            backGroundColor = Color.red;
                    }
                    else
                    {
                        if (EditorUtilities.ContainsInvalidFileNameCharacters(prefix))
                            backGroundColor = Color.red;
                    }
                    using (new EditorGUIHelper.GUIBackgroundColor(backGroundColor))
                    {
                        prefix = EditorGUILayout.TextField("File Prefix", prefix);
                    }


                    backGroundColor = Color.white;
                    if (string.IsNullOrEmpty(subFolderName.Trim()))
                    {
                        if (string.IsNullOrEmpty((prefix + suffix).Trim()) || EditorUtilities.ContainsInvalidFileNameCharacters(suffix))
                            backGroundColor = Color.red;
                    }
                    else
                    {
                        if (EditorUtilities.ContainsInvalidFileNameCharacters(suffix))
                            backGroundColor = Color.red;
                    }
                    using (new EditorGUIHelper.GUIBackgroundColor(backGroundColor))
                    {
                        suffix = EditorGUILayout.TextField("File Suffix", suffix);
                    }
                }

                GUILayout.Space(15);
                bool saveAvailable = true;
                string checkString = (prefix + suffix).Trim();
                if (string.IsNullOrEmpty(subFolderName.Trim()))
                {
                    if (string.IsNullOrEmpty(checkString) || EditorUtilities.ContainsInvalidFileNameCharacters(checkString))
                        saveAvailable = false;
                }
                else
                {
                    if (EditorUtilities.ContainsInvalidFileNameCharacters(subFolderName.Trim()))
                        saveAvailable = false;
                    else if (EditorUtilities.ContainsInvalidFileNameCharacters(checkString))
                        saveAvailable = false;
                }


                using (new EditorGUIHelper.GUIEnabled(saveAvailable))
                {
                    if (GUILayout.Button("Create Duplicate"))
                    {
                        this.Close();

                        callback(subFolderName.Trim(), prefix, suffix, objMaterial);
                    }
                }
            }
        }
    }
}