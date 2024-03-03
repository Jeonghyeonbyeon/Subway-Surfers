using System.IO;

using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    public class CurvedWorldBendSettingsTerrainDrawer : MaterialPropertyDrawer
    {
        private static class Label
        {
            public static string mainGroupName = "Curved World";

            public static string bendType = "Bend Type";
            public static string bendID = "Bend ID";
            public static string bendTransformNormal = "Transform Normal";
        }

        CurvedWorld.BEND_TYPE shaderSupportedBendType;
        int shaderSupportedBendID;

        CurvedWorld.BEND_TYPE updateBendType;
        int updateBendID;
        Material updateMaterial;


        void Init(string label)
        {
            CurvedWorld.BEND_TYPE[] bendTypes;
            int[] bendIDs;
            bool hasNormalTransform;

            if (EditorUtilities.StringToBendSettings(label, out bendTypes, out bendIDs, out hasNormalTransform))
            {
                shaderSupportedBendType = bendTypes[0];
                shaderSupportedBendID = bendIDs[0];
            }
        }


        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            Material material = (Material)editor.target;
            Init(prop.displayName);


            CurvedWorld.BEND_TYPE bendType;
            int bendID;
            bool normalTransform;

            EditorUtilities.GetBendSettingsFromVector(prop.vectorValue, out bendType, out bendID, out normalTransform);


            #region Bend Type               
            EditorGUI.BeginChangeCheck();
            using (new EditorGUIHelper.EditorGUILayoutBeginHorizontal())
            {
                bendType = (CurvedWorld.BEND_TYPE)EditorGUILayout.Popup(" ", (int)bendType, EditorUtilities.bendTypesNamesForMenu);
                EditorGUI.LabelField(GUILayoutUtility.GetLastRect(), "Bend Type", EditorUtilities.GetBendTypeNameInfo(bendType).forLable, EditorStyles.popup);

                if (GUILayout.Button("≡", GUILayout.MaxWidth(20)))
                {
                    GenericMenu menu = new GenericMenu();

                    menu.AddItem(new GUIContent("Find Controller"), false, EditorUtilities.CallbackFindController, (int)bendType + "_" + bendID);
                    menu.AddItem(new GUIContent("Editor Window"), false, EditorUtilities.CallbackOpenCurvedWorldSettingsWindow, (int)bendType + "_" + bendID);
                    menu.AddItem(new GUIContent("Curved World Keywords"), false, EditorUtilities.CallbackAnalyzeShaderCurvedWorldKeywords, material.shader);

                    menu.AddItem(new GUIContent("Reimport Shader"), false, EditorUtilities.CallbackReimportShader, material.shader);


                    menu.ShowAsContext();
                }
            }

            bendID = EditorGUILayout.IntSlider("Bend ID", bendID, 1, EditorUtilities.MAX_SUPPORTED_BEND_IDS);
            if (EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4((int)bendType, bendID, 0, 0);
            }


            if (bendType != shaderSupportedBendType || bendID != shaderSupportedBendID ||
                File.Exists(EditorUtilities.GetBendFileLocation(bendType, bendID, EditorUtilities.EXTENSTION.cginc)) == false)
            {
                EditorGUILayout.HelpBox("Missing Keywords!", MessageType.Error);

                Rect helpBox = GUILayoutUtility.GetLastRect();

                if (GUI.Button(new Rect(helpBox.xMax - 64 - 5, helpBox.yMin + 8, 64, 20), "Actions"))
                {
                    updateBendType = bendType;
                    updateBendID = bendID;
                    updateMaterial = material;

                    GenericMenu menu = new GenericMenu();
                    menu.AddItem(new GUIContent("Update Shader"), false, CallBackUpdateShader);
                    menu.ShowAsContext();
                }
            }
            #endregion
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return 0;
        }

        void CallBackUpdateShader()
        {
            string mainCGINCFilePath = EditorUtilities.GetGeneratedFilePath(updateBendType, updateBendID, EditorUtilities.EXTENSTION.cginc, false);
            if (File.Exists(mainCGINCFilePath) == false)
            {
                EditorUtilities.CreateCGINCFile(updateBendType, updateBendID);

                AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
            }


            string shaderPath = EditorUtilities.GetGeneratedTerrainShaderPath(updateBendType, updateBendID, false);
            if (File.Exists(shaderPath) == false)
            {
                string sourceFolderPath = EditorUtilities.GetTempleTerrainFolderPath();
                string desitnationFolderPath = EditorUtilities.GetGeneratedTerrainShadersFolderPath(updateBendType, updateBendID);


                //https://stackoverflow.com/questions/58744/copy-the-entire-contents-of-a-directory-in-c-sharp

                //Now Create all of the directories
                string[] directories = Directory.GetDirectories(sourceFolderPath, "*", SearchOption.AllDirectories);
                if (directories != null && directories.Length > 0)
                {
                    foreach (string dirPath in directories)
                        Directory.CreateDirectory(dirPath.Replace(sourceFolderPath, desitnationFolderPath));
                }
                else
                {
                    Directory.CreateDirectory(desitnationFolderPath);
                }

                //Copy all the files & Replaces any files with the same name
                foreach (string newPath in Directory.GetFiles(sourceFolderPath, "*.*",
                    SearchOption.AllDirectories))
                    File.Copy(newPath, newPath.Replace(sourceFolderPath, desitnationFolderPath), true);



                //Deleta all meta files
                string[] allMetaFiles = Directory.GetFiles(desitnationFolderPath, "*.meta", SearchOption.AllDirectories);
                foreach (string metaFile in allMetaFiles)
                {
                    System.IO.File.Delete(metaFile);
                }


                //Read all files and make changes
                string BEND_NAME_SMALL = EditorUtilities.GetBendTypeNameInfo(updateBendType).forLable;
                string BEND_NAME_BIG = updateBendType.ToString().ToUpperInvariant();
                string BEND_NAME_INDEX = ((int)updateBendType).ToString();
                string ID = updateBendID.ToString();

                string[] allShaderFiles = Directory.GetFiles(desitnationFolderPath, "*", SearchOption.AllDirectories);
                foreach (string shaderFile in allShaderFiles)
                {
                    string[] allLines = File.ReadAllLines(shaderFile);

                    for (int i = 0; i < allLines.Length; i++)
                    {
                        allLines[i] = allLines[i].Replace("#BEND_NAME_SMALL#", BEND_NAME_SMALL).
                                                  Replace("#ID#", ID).
                                                  Replace("#BEND_NAME_INDEX#", BEND_NAME_INDEX).
                                                  Replace("#BEND_NAME_BIG#", BEND_NAME_BIG);
                    }

                    File.WriteAllLines(shaderFile, allLines);
                }

                //Change .txt files extension to .shader
                string[] allTxtFiles = Directory.GetFiles(desitnationFolderPath, "*.txt", SearchOption.AllDirectories);
                foreach (string txtFile in allTxtFiles)
                {
                    File.Move(txtFile, Path.ChangeExtension(txtFile, ".shader"));
                }


                AssetDatabase.Refresh();
            }

            updateMaterial.shader = (Shader)AssetDatabase.LoadAssetAtPath(shaderPath, typeof(Shader));
        }
    }
}