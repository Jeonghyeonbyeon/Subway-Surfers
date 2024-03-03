using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    public static class EditorUtilities
    {
        public enum EXTENSTION { cginc, UnityShaderGraphNormal, UnityShaderGraphVertex, AmplifyShaderEditorNormal, AmplifyShaderEditorVertex }
        public enum KEYWORDS_COMPILE { Default, ShaderFeature, MultiCompile }
        public enum RENDER_PIPELINE { Builtin, Universal, HighDefinition }
        public enum ACTIVATE_STATE { Done, Skip, Problem }



        static public readonly int MAX_SUPPORTED_BEND_IDS = 32;
        static public readonly int MAX_SUPPORTED_BEND_TYPES = Enum.GetValues(typeof(CurvedWorld.BEND_TYPE)).Length;
        static public string[] bendTypesNamesForLabel = Enum.GetValues(typeof(CurvedWorld.BEND_TYPE)).Cast<int>().Select(x => EditorUtilities.GetBendTypeNameInfo((CurvedWorld.BEND_TYPE)x).forLable).ToArray();
        static public string[] bendTypesNamesForMenu = Enum.GetValues(typeof(CurvedWorld.BEND_TYPE)).Cast<int>().Select(x => EditorUtilities.GetBendTypeNameInfo((CurvedWorld.BEND_TYPE)x).forMenu).ToArray();


        static public string shaderProprtyName_BendSettings = "_CurvedWorldBendSettings";
        static public string shaderKeywordName_CurvedWorldDisabled = "CURVEDWORLD_DISABLED_ON";
        static public string shaderKeywordName_BendTransformNormal = "CURVEDWORLD_NORMAL_TRANSFORMATION_ON";
        static public string shaderKeywordPrefix_BendType = "CURVEDWORLD_BEND_TYPE_";
        static public string shaderKeywordPrefix_BendID = "CURVEDWORLD_BEND_ID_";


        static public char[] invalidFileNameCharachters = Path.GetInvalidFileNameChars();


        static string curvedWorldEditorFolderPath;
        static string curvedWorldTransformFilePath;
        static string amplifyShaderEditorWindowPath;



        static public string GetCurvedWorldEditorFolderPath()
        {
            if (string.IsNullOrEmpty(curvedWorldEditorFolderPath))
            {
                string[] assets = AssetDatabase.FindAssets("CurvedWorldTransform");

                if (assets != null && assets.Length > 0)
                {
                    for (int i = 0; i < assets.Length; i++)
                    {
                        if (string.IsNullOrEmpty(assets[i]) == false)
                        {
                            string currentFilePath = AssetDatabase.GUIDToAssetPath(assets[i]);

                            if (currentFilePath.Contains("Amazing Assets") &&
                                currentFilePath.Contains("Curved World") &&
                                currentFilePath.Contains("Shaders") &&
                                currentFilePath.Contains("Core") &&
                                Path.GetExtension(currentFilePath) == ".cginc")

                            {
                                curvedWorldEditorFolderPath = Path.GetDirectoryName(Path.GetDirectoryName(Path.GetDirectoryName(currentFilePath)));
                                break;
                            }
                        }
                    }
                }
            }

            return curvedWorldEditorFolderPath;
        }

        static public string GetCoreTransformFilePath()
        {
            if (string.IsNullOrEmpty(curvedWorldTransformFilePath) || File.Exists(curvedWorldTransformFilePath) == false)
            {
                curvedWorldTransformFilePath = Path.Combine(GetCurvedWorldEditorFolderPath(), "Shaders", "Core", "CurvedWorldTransform.cginc");
            }

            return curvedWorldTransformFilePath;
        }

        static public string GetCoreTransformFilePathForShader()
        {
            string pathToTransformCGINC = "\"" + GetCoreTransformFilePath() + "\"";
            pathToTransformCGINC = pathToTransformCGINC.Replace(Path.DirectorySeparatorChar, '/');
            pathToTransformCGINC = pathToTransformCGINC.Replace('\\', '/');

            return "#include " + pathToTransformCGINC;
        }

        static public string GetBendFileLocation(CurvedWorld.BEND_TYPE bendType, int bendID, EXTENSTION extention)
        {           
            bendID = (int)Mathf.Clamp(bendID, 1, EditorUtilities.MAX_SUPPORTED_BEND_IDS);


            switch (extention)
            {
                case EXTENSTION.cginc:
                    return GetGeneratedFilePath(bendType, bendID, EXTENSTION.cginc, false);

                case EXTENSTION.UnityShaderGraphNormal:
                    return GetGeneratedFilePath(bendType, bendID, EXTENSTION.UnityShaderGraphNormal, false);

                case EXTENSTION.UnityShaderGraphVertex:
                    return GetGeneratedFilePath(bendType, bendID, EXTENSTION.UnityShaderGraphVertex, false);

                case EXTENSTION.AmplifyShaderEditorNormal:
                    return GetGeneratedFilePath(bendType, bendID, EXTENSTION.AmplifyShaderEditorNormal, false);

                case EXTENSTION.AmplifyShaderEditorVertex:
                    return GetGeneratedFilePath(bendType, bendID, EXTENSTION.AmplifyShaderEditorVertex, false);

                default:
                    return string.Empty;
            }
        }


        static CurvedWorld.BEND_TYPE[] StringToBendTypes(string bendTypesString)
        {
            List<CurvedWorld.BEND_TYPE> list = new List<CurvedWorld.BEND_TYPE>();


            if (string.IsNullOrEmpty(bendTypesString) == false)
            {
                bendTypesString = bendTypesString.Replace("\"", string.Empty).Trim();

                string[] bendTypes = bendTypesString.Split(',');

                if (bendTypes != null && bendTypes.Length > 0)
                {
                    for (int j = 0; j < bendTypes.Length; j++)
                    {
                        CurvedWorld.BEND_TYPE bt;
                        if (System.Enum.TryParse(bendTypes[j], out bt))
                        {
                            list.Add(bt);
                        }
                    }
                }
            }

            return list.ToArray();
        }

        static int[] StringToBendIDs(string bendTypesString)
        {
            List<int> list = new List<int>();


            if (string.IsNullOrEmpty(bendTypesString) == false)
            {
                bendTypesString = bendTypesString.Replace("\"", string.Empty).Trim();

                string[] bendTypes = bendTypesString.Split(',');

                if (bendTypes != null && bendTypes.Length > 0)
                {
                    for (int j = 0; j < bendTypes.Length; j++)
                    {
                        int iOut;
                        if (int.TryParse(bendTypes[j], out iOut))
                        {
                            if (iOut >= 1 && iOut <= EditorUtilities.MAX_SUPPORTED_BEND_IDS)
                                list.Add(iOut);
                        }
                    }
                }
            }

            return list.ToArray();
        }

        static bool StringToNormalTransform(string normalTransfromString)
        {
            bool value = false;
            if (string.IsNullOrEmpty(normalTransfromString) == false && normalTransfromString.Length == 1 && normalTransfromString == "1")
                value = true;

            return value;
        }


        static public bool StringToBendSettings(string label, out CurvedWorld.BEND_TYPE[] bendTypes, out int[] bendIDs, out bool hasNormalTransform)
        {
            bendTypes = null;
            bendIDs = null;
            hasNormalTransform = false;

            if (string.IsNullOrEmpty(label) == false)
            {
                string[] bendSettings = label.Replace("\"", string.Empty).Trim().Split('|');

                if (bendSettings != null)
                {
                    if (bendSettings.Length == 2)
                    {
                        bendTypes = StringToBendTypes(bendSettings[0]);
                        bendIDs = StringToBendIDs(bendSettings[1]);
                        hasNormalTransform = false;

                        return true;
                    }
                    else if (bendSettings.Length == 3)
                    {
                        bendTypes = StringToBendTypes(bendSettings[0]);
                        bendIDs = StringToBendIDs(bendSettings[1]);
                        hasNormalTransform = StringToNormalTransform(bendSettings[2]);

                        return true;
                    }

                }
            }

            return false;
        }

        static public string BendSettingsToString(CurvedWorld.BEND_TYPE[] bendTypes, int[] bendIDs, bool hasNormalTransform)
        {
            if (bendTypes == null || bendTypes.Length == 0 || bendIDs == null || bendIDs.Length == 0)
                return string.Empty;

            bendTypes = (new List<CurvedWorld.BEND_TYPE>(bendTypes)).Distinct().OrderBy(x => (int)x).ToArray();
            bendIDs = (new List<int>(bendIDs)).Distinct().OrderBy(x => x).ToArray();


            return String.Join(",", bendTypes.Select(p => (int)p)) + "|" + String.Join(",", bendIDs) + (hasNormalTransform ? "|1" : string.Empty);
        }

        static public void GetBendSettingsFromVector(Vector4 prop, out CurvedWorld.BEND_TYPE bendType, out int bendID, out bool normalTransform)
        {
            bendType = (CurvedWorld.BEND_TYPE)prop[0];
            bendID = prop[1] <= 1 ? 1 : (int)prop[1];
            normalTransform = prop[2] == 1 ? true : false;
        }

        static public bool GetShaderSupportedBendSettings(Shader shader, out CurvedWorld.BEND_TYPE[] bendTypes, out int[] bendIDs, out bool hasNormalTransform)
        {
            bendTypes = null;
            bendIDs = null;
            hasNormalTransform = false;


            for (int i = 0; i < ShaderUtil.GetPropertyCount(shader); i++)
            {
                if (ShaderUtil.GetPropertyName(shader, i) == shaderProprtyName_BendSettings)
                {
                    string propertyDescription = ShaderUtil.GetPropertyDescription(shader, i);

                    if (StringToBendSettings(propertyDescription, out bendTypes, out bendIDs, out hasNormalTransform))
                        break;
                }
            }

            if (bendTypes != null && bendTypes.Length > 0 &&
               bendIDs != null && bendIDs.Length > 0)
            {
                return true;
            }
            else
            {
                bendTypes = null;
                bendIDs = null;

                return false;
            }

        }

        static public bool AddShaderBendSettings(Shader shader, CurvedWorld.BEND_TYPE bendType, int bendID, KEYWORDS_COMPILE keywordsCompile, bool reimport)
        {
            CurvedWorld.BEND_TYPE[] bendTypes;
            int[] bendIDs;
            bool hasNormalTransform;

            if (GetShaderSupportedBendSettings(shader, out bendTypes, out bendIDs, out hasNormalTransform))
            {
                if (bendTypes.Contains(bendType) == false)
                {
                    List<CurvedWorld.BEND_TYPE> temp = new List<CurvedWorld.BEND_TYPE>(bendTypes);
                    temp.Add(bendType);

                    bendTypes = temp.ToArray();
                }

                if (bendIDs.Contains(bendID) == false)
                {
                    List<int> temp = new List<int>(bendIDs);
                    temp.Add(bendID);

                    bendIDs = temp.ToArray();
                }


                return SetShaderBendSettings(shader, bendTypes, bendIDs, keywordsCompile, reimport);
            }

            return false;
        }

        static public bool SetShaderBendSettings(Shader shader, CurvedWorld.BEND_TYPE[] bendTypes, int[] bendIDs, KEYWORDS_COMPILE keywordsCompile, bool reimport)
        {
            if (shader == null)
                return false;


            if (bendTypes == null || bendTypes.Length == 0)
                bendTypes = new CurvedWorld.BEND_TYPE[] { CurvedWorld.BEND_TYPE.ClassicRunner_X_Positive };

            if (bendIDs == null || bendIDs.Length == 0)
                bendIDs = new int[] { 1 };


            string propDescription = string.Empty;
            for (int i = 0; i < ShaderUtil.GetPropertyCount(shader); i++)
            {
                if (ShaderUtil.GetPropertyName(shader, i) == shaderProprtyName_BendSettings)
                {
                    propDescription = "\"" + ShaderUtil.GetPropertyDescription(shader, i).Trim() + "\"";
                    break;
                }
            }

            if (string.IsNullOrEmpty(propDescription))
                return false;



            string shaderFilePath = AssetDatabase.GetAssetPath(shader.GetInstanceID());
            if (string.IsNullOrEmpty(shaderFilePath))
                return false;



            string label = "\"" + BendSettingsToString(bendTypes, bendIDs, HasShaderNormalTransform(shader)) + "\"";


            string bendTypeKeywordString = null;
            string bendIDKeywordString = null;



            string[] allLines = File.ReadAllLines(shaderFilePath);

            bool replaceProperty = false;
            bool replaceBendTypeDefinitions = false;
            bool replaceBendIDDefinitions = false;

            //Replace Property
            for (int i = 0; i < allLines.Length; i++)
            {
                //Replace property 
                if (replaceProperty == false && allLines[i].Contains(shaderProprtyName_BendSettings) && allLines[i].Contains(propDescription))
                {
                    if (StringIsCommented(allLines[i]) == false)
                    {
                        allLines[i] = allLines[i].Replace(propDescription, label);

                        replaceProperty = true;
                        break;
                    }
                }
            }

            for (int i = 0; i < allLines.Length; i++)
            {
                //Replace Bend Type Keyword
                if (allLines[i].Contains(shaderKeywordPrefix_BendType) &&
                    (allLines[i].Contains("#define") || allLines[i].Contains("#pragma")))
                {
                    if (StringIsCommented(allLines[i]))
                        continue;

                    if (string.IsNullOrEmpty(bendTypeKeywordString))
                    {
                        if (bendTypes.Length == 1)
                        {
                            bendTypeKeywordString = "#define " + GetKeywordName(bendTypes[0]);
                        }
                        else
                        {
                            switch (keywordsCompile)
                            {
                                case KEYWORDS_COMPILE.ShaderFeature:
                                    bendTypeKeywordString = "#pragma shader_feature_local";
                                    break;

                                case KEYWORDS_COMPILE.MultiCompile:
                                    bendTypeKeywordString = "#pragma multi_compile_local";
                                    break;

                                default:
                                    bendTypeKeywordString = allLines[i].Contains("multi_compile_local") ? "#pragma multi_compile_local" : "#pragma shader_feature_local";
                                    break;
                            }

                            for (int j = 0; j < bendTypes.Length; j++)
                            {
                                bendTypeKeywordString += " " + GetKeywordName(bendTypes[j]);
                            }
                        }
                    }

                    allLines[i] = bendTypeKeywordString;

                    replaceBendTypeDefinitions = true;
                }


                //Replace Bend ID Keyword
                if (allLines[i].Contains(shaderKeywordPrefix_BendID) &&
                    (allLines[i].Contains("#define") || allLines[i].Contains("#pragma")))
                {

                    if (StringIsCommented(allLines[i]))
                        continue;

                    if (string.IsNullOrEmpty(bendIDKeywordString))
                    {
                        if (bendIDs.Length == 1)
                        {
                            bendIDKeywordString = "#define " + GetKeywordName(bendIDs[0]);
                        }
                        else
                        {
                            bendIDKeywordString = string.Empty;
                            switch (keywordsCompile)
                            {
                                case KEYWORDS_COMPILE.ShaderFeature:
                                    bendIDKeywordString = "#pragma shader_feature_local";
                                    break;

                                case KEYWORDS_COMPILE.MultiCompile:
                                    bendIDKeywordString = "#pragma multi_compile_local";
                                    break;

                                default:
                                    bendIDKeywordString = allLines[i].Contains("multi_compile_local") ? "#pragma multi_compile_local" : "#pragma shader_feature_local";
                                    break;
                            }

                            for (int j = 0; j < bendIDs.Length; j++)
                            {
                                bendIDKeywordString += " " + GetKeywordName(bendIDs[j]);
                            }
                        }
                    }

                    allLines[i] = bendIDKeywordString;

                    replaceBendIDDefinitions = true;
                }
            }


            File.WriteAllLines(shaderFilePath, allLines);


            if (reimport)
                AssetDatabase.ImportAsset(shaderFilePath);


            if (replaceProperty && replaceBendTypeDefinitions && replaceBendIDDefinitions)
                return true;
            else
            {
                return false;
            }
        }

        static public void SetMaterialBendSettings(Material material, CurvedWorld.BEND_TYPE bendType, int bendID, bool normalTransform)
        {
            if (material != null && material.shader != null && material.HasProperty(shaderProprtyName_BendSettings))
            {
                bendID = Mathf.Clamp(bendID, 1, MAX_SUPPORTED_BEND_IDS);


                //Setup shader Bend Type
                CurvedWorld.BEND_TYPE[] shadersBendTypes;
                int[] shadersBendIDs;
                bool hasNormalTransform;

                if (GetShaderSupportedBendSettings(material.shader, out shadersBendTypes, out shadersBendIDs, out hasNormalTransform))
                {
                    if (shadersBendTypes.Contains(bendType) == false)
                    {
                        List<CurvedWorld.BEND_TYPE> temp = new List<CurvedWorld.BEND_TYPE>(shadersBendTypes);
                        temp.Add(bendType);

                        shadersBendTypes = temp.ToArray();
                    }

                    if (shadersBendIDs.Contains(bendID) == false)
                    {
                        List<int> temp = new List<int>(shadersBendIDs);
                        temp.Add(bendID);

                        shadersBendIDs = temp.ToArray();
                    }

                    SetShaderBendSettings(material.shader, shadersBendTypes, shadersBendIDs, KEYWORDS_COMPILE.Default, false);


                    UpdateMaterialKeyWords(material, bendType, bendID, normalTransform);
                }
                else
                {
                    UpdateMaterialKeyWords(material, bendType, bendID, normalTransform);
                }
            }
        }

        static public void UpdateMaterialKeyWords(Material material, CurvedWorld.BEND_TYPE bendType, int bendID, bool normalTransform)
        {
            if (material == null || material.shader == null)
                return;


            if (normalTransform && HasShaderNormalTransform(material.shader) == false)
                normalTransform = false;



            List<string> keyWords = new List<string>(material.shaderKeywords);
            for (int i = keyWords.Count - 1; i >= 0; i -= 1)
            {
                if (keyWords[i].Contains(shaderKeywordPrefix_BendType) || keyWords[i].Contains(shaderKeywordPrefix_BendID))
                {
                    material.DisableKeyword(keyWords[i]);

                    keyWords.RemoveAt(i);
                }
            }

            material.DisableKeyword(shaderKeywordName_BendTransformNormal);
            keyWords.Remove(EditorUtilities.shaderKeywordName_BendTransformNormal);


            //Bend Type
            keyWords.Add(GetKeywordName(bendType));

            //Bend ID
            keyWords.Add(GetKeywordName(bendID));

            if (normalTransform)
                keyWords.Add(EditorUtilities.shaderKeywordName_BendTransformNormal);


            material.shaderKeywords = null;
            material.shaderKeywords = keyWords.ToArray();


            //Enable keywords
            {
                material.EnableKeyword(GetKeywordName(bendType));
                material.EnableKeyword(GetKeywordName(bendID));

                if (normalTransform)
                    material.EnableKeyword(shaderKeywordName_BendTransformNormal);
            }


            if (material.HasProperty(shaderProprtyName_BendSettings))
            {
                Vector4 prop = material.GetVector(shaderProprtyName_BendSettings);

                prop.x = (int)bendType;
                prop.y = bendID;
                prop.z = normalTransform ? 1 : 0;


                material.SetVector(shaderProprtyName_BendSettings, prop);
            }
        }

        static public bool HasShaderCurvedWorldBendSettingsProperty(Shader shader)
        {
            if (shader != null)
            {
                for (int i = 0; i < ShaderUtil.GetPropertyCount(shader); i++)
                {
                    if (ShaderUtil.GetPropertyName(shader, i) == shaderProprtyName_BendSettings)
                        return true;
                }
            }

            return false;
        }

        static public bool HasShaderNormalTransform(Shader shader)
        {
            CurvedWorld.BEND_TYPE[] bendType;
            int[] bendID;
            bool hasNormalTransform;

            if (GetShaderSupportedBendSettings(shader, out bendType, out bendID, out hasNormalTransform))
            {
                return hasNormalTransform;
            }

            return false;
        }

        static public bool IsShaderCurvedWorldTerrain(Shader shader)
        {
            if (shader == null || string.IsNullOrEmpty(shader.name))
                return false;

            return shader.name.Contains("Amazing Assets/Curved World") && shader.name.Contains("Terrain");
        }



        static public string GetGeneratedFilePath(CurvedWorld.BEND_TYPE bendType, int bendID, EXTENSTION extention, bool createFolder)
        {
            string filePath = string.Empty;


            switch (extention)
            {
                case EXTENSTION.cginc:   //Main CGINC
                    filePath = GetCurvedWorldEditorFolderPath();
                    filePath = Path.Combine(filePath, "Shaders");
                    filePath = Path.Combine(filePath, "CGINC");
                    if (createFolder && Directory.Exists(filePath) == false)
                        Directory.CreateDirectory(filePath);

                    filePath = Path.Combine(filePath, GetBendTypeNameInfo(bendType).nameOnly);
                    if (createFolder && Directory.Exists(filePath) == false)
                        Directory.CreateDirectory(filePath);

                    filePath = Path.Combine(filePath, ("CurvedWorld_" + bendType.ToString() + "_ID" + bendID) + ".cginc");
                    break;

                case EXTENSTION.AmplifyShaderEditorNormal:   //Amplify Shder Editor
                case EXTENSTION.AmplifyShaderEditorVertex:
                    filePath = GetCurvedWorldEditorFolderPath();
                    filePath = Path.Combine(filePath, "Shaders");
                    filePath = Path.Combine(filePath, "Amplify Shader Editor");
                    if (createFolder && Directory.Exists(filePath) == false)
                        Directory.CreateDirectory(filePath);

                    filePath = Path.Combine(filePath, GetBendTypeNameInfo(bendType).nameOnly);
                    if (createFolder && Directory.Exists(filePath) == false)
                        Directory.CreateDirectory(filePath);

                    filePath = Path.Combine(filePath, ("CurvedWorld_" + bendType.ToString() + "_ID" + bendID) + (extention == EXTENSTION.AmplifyShaderEditorNormal ? "_Normal" : "_Vertex") + ".asset");
                    break;

                case EXTENSTION.UnityShaderGraphNormal:  //Unity Shader Graph
                case EXTENSTION.UnityShaderGraphVertex:
                    filePath = GetCurvedWorldEditorFolderPath();
                    filePath = Path.Combine(filePath, "Shaders");

                    filePath = Path.Combine(filePath, "Unity Shader Graph");
                    if (createFolder && Directory.Exists(filePath) == false)
                        Directory.CreateDirectory(filePath);

                    filePath = Path.Combine(filePath, GetBendTypeNameInfo(bendType).nameOnly);
                    if (createFolder && Directory.Exists(filePath) == false)
                        Directory.CreateDirectory(filePath);

                    filePath = Path.Combine(filePath, ("CurvedWorld_" + bendType.ToString() + "_ID" + bendID) + (extention == EXTENSTION.UnityShaderGraphNormal ? "_Normal" : "_Vertex") + ".shadersubgraph");
                    break;

                default:
                    break;
            }


            return filePath;
        }

        static public string GetTempleFilePath(CurvedWorld.BEND_TYPE bendType, EXTENSTION extention)
        {
            string filePath = string.Empty;

            switch (extention)
            {
                case EXTENSTION.cginc:
                    filePath = GetCurvedWorldEditorFolderPath();
                    filePath = Path.Combine(filePath, "Shaders");
                    filePath = Path.Combine(filePath, "Templates");
                    filePath = Path.Combine(filePath, "Template_" + GetBendTypeNameInfo(bendType).templateFileName + ".txt");
                    break;

                case EXTENSTION.AmplifyShaderEditorNormal:
                case EXTENSTION.AmplifyShaderEditorVertex:
                    filePath = GetCurvedWorldEditorFolderPath();
                    filePath = Path.Combine(filePath, "Shaders");
                    filePath = Path.Combine(filePath, "Templates");
                    filePath = Path.Combine(filePath, "Template_AmplifyShaderEditor_" + (extention == EXTENSTION.AmplifyShaderEditorNormal ? "Normal" : "Vertex") + ".txt");
                    break;

                case EXTENSTION.UnityShaderGraphNormal:
                case EXTENSTION.UnityShaderGraphVertex:
                    filePath = GetCurvedWorldEditorFolderPath();
                    filePath = Path.Combine(filePath, "Shaders");
                    filePath = Path.Combine(filePath, "Templates");
                    filePath = Path.Combine(filePath, "Template_UnityShaderGraph_" + (extention == EXTENSTION.UnityShaderGraphNormal ? "Normal" : "Vertex") + ".txt");
                    break;

                default:
                    break;
            }


            if (File.Exists(filePath))
                return filePath;
            else
                return string.Empty;
        }


        static public string GetGeneratedTerrainShaderPath(CurvedWorld.BEND_TYPE bendType, int ID, bool createFolder)
        {
            if (ID < 1)
                ID = 1;


            string filePath = string.Empty;


            filePath = GetCurvedWorldEditorFolderPath();
            filePath = Path.Combine(filePath, "Shaders", "Custom");
            if (createFolder && Directory.Exists(filePath) == false)
                Directory.CreateDirectory(filePath);

            filePath = Path.Combine(filePath, "Terrain");
            if (createFolder && Directory.Exists(filePath) == false)
                Directory.CreateDirectory(filePath);

            filePath = Path.Combine(filePath, GetBendTypeNameInfo(bendType).forLable + " ID" + ID);
            if (createFolder && Directory.Exists(filePath) == false)
                Directory.CreateDirectory(filePath);

            if (GetCurrentRenderPipeline() == RENDER_PIPELINE.Builtin)
            {
                filePath = Path.Combine(filePath, "Splats");
                if (createFolder && Directory.Exists(filePath) == false)
                    Directory.CreateDirectory(filePath);

                filePath = Path.Combine(filePath, "FirstPass.shader");
            }
            else
            {
                filePath = Path.Combine(filePath, "TerrainLit.shader");
            }

            return filePath;
        }

        static public string GetGeneratedTerrainShadersFolderPath(CurvedWorld.BEND_TYPE bendType, int ID)
        {
            string filePath = string.Empty;


            filePath = GetCurvedWorldEditorFolderPath();
            filePath = Path.Combine(filePath, "Shaders", "Custom", "Terrain");
            filePath = Path.Combine(filePath, GetBendTypeNameInfo(bendType).forLable + " ID" + ID);

            return filePath;
        }

        static public string GetTempleTerrainFolderPath()
        {
            string filePath = string.Empty;

            filePath = GetCurvedWorldEditorFolderPath();
            filePath = Path.Combine(filePath, "Shaders", "Templates", "Terrain");

            return filePath;
        }


        public static string CreateCGINCFile(CurvedWorld.BEND_TYPE _BendType, int _BendID)
        {
            string templateFileLocation = EditorUtilities.GetTempleFilePath(_BendType, EditorUtilities.EXTENSTION.cginc);
            if (File.Exists(templateFileLocation) == false)
                return string.Empty;


            string[] templateFileAllLines = File.ReadAllLines(templateFileLocation);
            if (templateFileAllLines == null || templateFileAllLines.Length == 0)
                return null;



            if (_BendID < 1)
                _BendID = 1;

            string[] localFile = new string[templateFileAllLines.Length];

            for (int i = 0; i < templateFileAllLines.Length; i++)
            {
                localFile[i] = templateFileAllLines[i].Replace("#BEND_TYPE_SMALL#", _BendType.ToString()).
                                                       Replace("#BEND_TYPE_BIG#", _BendType.ToString().ToUpperInvariant()).
                                                       Replace("#ID#", _BendID.ToString());
            }


            string saveLocalFileName = EditorUtilities.GetGeneratedFilePath(_BendType, _BendID, EditorUtilities.EXTENSTION.cginc, true);

            if (string.IsNullOrEmpty(saveLocalFileName) == false)
            {
                File.WriteAllLines(saveLocalFileName, localFile);


                return saveLocalFileName;
            }
            else
                return null;
        }

        public static void CreateSubGraphFile(CurvedWorld.BEND_TYPE _BendType, int _BendID, string localGUID, EditorUtilities.EXTENSTION extention)
        {
            string templateFileLocation = EditorUtilities.GetTempleFilePath(_BendType, extention);
            if (File.Exists(templateFileLocation) == false)
                return;


            string[] templateFileAllLines = File.ReadAllLines(templateFileLocation);
            if (templateFileAllLines == null || templateFileAllLines.Length == 0)
            {
                Debug.LogWarning("Template file for " + _BendType.ToString() + " not found: ");
                return;
            }


            EditorUtilities.BendTypeNameInfo bandTypeNameInfo = EditorUtilities.GetBendTypeNameInfo(_BendType);

            string[] subGraphFile = new string[templateFileAllLines.Length];

            for (int i = 0; i < templateFileAllLines.Length; i++)
            {
                subGraphFile[i] = templateFileAllLines[i].Replace("#BEND_TYPE_SMALL#", _BendType.ToString()).
                                                          Replace("#BEND_TYPE_BIG#", _BendType.ToString().ToUpperInvariant()).
                                                          Replace("#ID#", _BendID.ToString()).
                                                          Replace("#BEND_NAME#", bandTypeNameInfo.nameOnly).
                                                          Replace("#BEND_AXIS#", string.IsNullOrEmpty(bandTypeNameInfo.axisOnly) ? string.Empty : "/" + bandTypeNameInfo.axisOnly).
                                                          Replace("#CGINC_FILE_GUID#", localGUID);
            }




            string saveLocalFileName = EditorUtilities.GetGeneratedFilePath(_BendType, _BendID, extention, true);
            if (string.IsNullOrEmpty(saveLocalFileName) == false)
            {
                File.WriteAllLines(saveLocalFileName, subGraphFile);
            }
        }



        static public BendTypeNameInfo GetBendTypeNameInfo(CurvedWorld.BEND_TYPE _bendType)
        {
            BendTypeNameInfo nameInfo;

            nameInfo.nameOnly = string.Empty;
            nameInfo.nameOnlyWithoutSpace = string.Empty;
            nameInfo.axisOnly = string.Empty;
            nameInfo.forLable = string.Empty;
            nameInfo.forMenu = string.Empty;
            nameInfo.templateFileName = string.Empty;


            switch (_bendType)
            {
                case CurvedWorld.BEND_TYPE.ClassicRunner_X_Positive:
                    nameInfo.nameOnly = "Classic Runner";
                    nameInfo.nameOnlyWithoutSpace = "ClassicRunner";
                    nameInfo.axisOnly = "X Positive";
                    nameInfo.forLable = "Classic Runner (X Positive)";
                    nameInfo.forMenu = "Classic Runner/X Positive";
                    nameInfo.templateFileName = "ClassicRunner";
                    break;
                case CurvedWorld.BEND_TYPE.ClassicRunner_X_Negative:
                    nameInfo.nameOnly = "Classic Runner";
                    nameInfo.nameOnlyWithoutSpace = "ClassicRunner";
                    nameInfo.axisOnly = "X Negative";
                    nameInfo.forLable = "Classic Runner (X Negative)";
                    nameInfo.forMenu = "Classic Runner/X Negative";
                    nameInfo.templateFileName = "ClassicRunner";
                    break;
                case CurvedWorld.BEND_TYPE.ClassicRunner_Z_Positive:
                    nameInfo.nameOnly = "Classic Runner";
                    nameInfo.nameOnlyWithoutSpace = "ClassicRunner";
                    nameInfo.axisOnly = "Z Positive";
                    nameInfo.forLable = "Classic Runner (Z Positive)";
                    nameInfo.forMenu = "Classic Runner/Z Positive";
                    nameInfo.templateFileName = "ClassicRunner";
                    break;
                case CurvedWorld.BEND_TYPE.ClassicRunner_Z_Negative:
                    nameInfo.nameOnly = "Classic Runner";
                    nameInfo.nameOnlyWithoutSpace = "ClassicRunner";
                    nameInfo.axisOnly = "Z Negative";
                    nameInfo.forLable = "Classic Runner (Z Negative)";
                    nameInfo.forMenu = "Classic Runner/Z Negative";
                    nameInfo.templateFileName = "ClassicRunner";
                    break;

                case CurvedWorld.BEND_TYPE.LittlePlanet_X:
                    nameInfo.nameOnly = "Little Planet";
                    nameInfo.nameOnlyWithoutSpace = "LittlePlanet";
                    nameInfo.axisOnly = "X";
                    nameInfo.forLable = "Little Planet (X)";
                    nameInfo.forMenu = "Little Planet/X";
                    nameInfo.templateFileName = "LittlePlanet";
                    break;
                case CurvedWorld.BEND_TYPE.LittlePlanet_Y:
                    nameInfo.nameOnly = "Little Planet";
                    nameInfo.nameOnlyWithoutSpace = "LittlePlanet";
                    nameInfo.axisOnly = "Y";
                    nameInfo.forLable = "Little Planet (Y)";
                    nameInfo.forMenu = "Little Planet/Y";
                    nameInfo.templateFileName = "LittlePlanet";
                    break;
                case CurvedWorld.BEND_TYPE.LittlePlanet_Z:
                    nameInfo.nameOnly = "Little Planet";
                    nameInfo.nameOnlyWithoutSpace = "LittlePlanet";
                    nameInfo.axisOnly = "Z";
                    nameInfo.forLable = "Little Planet (Z)";
                    nameInfo.forMenu = "Little Planet/Z";
                    nameInfo.templateFileName = "LittlePlanet";
                    break;


                case CurvedWorld.BEND_TYPE.CylindricalRolloff_X:
                    nameInfo.nameOnly = "Cylindrical Rolloff";
                    nameInfo.nameOnlyWithoutSpace = "CylindricalRolloff";
                    nameInfo.axisOnly = "X";
                    nameInfo.forLable = "Cylindrical Rolloff (X)";
                    nameInfo.forMenu = "Cylindrical Rolloff/X";
                    nameInfo.templateFileName = "CylindricalRolloff";
                    break;
                case CurvedWorld.BEND_TYPE.CylindricalRolloff_Z:
                    nameInfo.nameOnly = "Cylindrical Rolloff";
                    nameInfo.nameOnlyWithoutSpace = "CylindricalRolloff";
                    nameInfo.axisOnly = "Z";
                    nameInfo.forLable = "Cylindrical Rolloff (Z)";
                    nameInfo.forMenu = "Cylindrical Rolloff/Z";
                    nameInfo.templateFileName = "CylindricalRolloff";
                    break;


                case CurvedWorld.BEND_TYPE.CylindricalTower_X:
                    nameInfo.nameOnly = "Cylindrical Tower";
                    nameInfo.nameOnlyWithoutSpace = "CylindricalTower";
                    nameInfo.axisOnly = "X";
                    nameInfo.forLable = "Cylindrical Tower (X)";
                    nameInfo.forMenu = "Cylindrical Tower/X";
                    nameInfo.templateFileName = "CylindricalTower";
                    break;
                case CurvedWorld.BEND_TYPE.CylindricalTower_Z:
                    nameInfo.nameOnly = "Cylindrical Tower";
                    nameInfo.nameOnlyWithoutSpace = "CylindricalTower";
                    nameInfo.axisOnly = "Z";
                    nameInfo.forLable = "Cylindrical Tower (Z)";
                    nameInfo.forMenu = "Cylindrical Tower/Z";
                    nameInfo.templateFileName = "CylindricalTower";
                    break;


                case CurvedWorld.BEND_TYPE.SpiralHorizontal_X_Positive:
                    nameInfo.nameOnly = "Spiral Horizontal";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontal";
                    nameInfo.axisOnly = "X Positive";
                    nameInfo.forLable = "Spiral Horizontal (X Positive)";
                    nameInfo.forMenu = "Spiral Horizontal/X Positive";
                    nameInfo.templateFileName = "Spiral";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralHorizontal_X_Negative:
                    nameInfo.nameOnly = "Spiral Horizontal";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontal";
                    nameInfo.axisOnly = "X Negative";
                    nameInfo.forLable = "Spiral Horizontal (X Negative)";
                    nameInfo.forMenu = "Spiral Horizontal/X Negative";
                    nameInfo.templateFileName = "Spiral";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralHorizontal_Z_Positive:
                    nameInfo.nameOnly = "Spiral Horizontal";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontal";
                    nameInfo.axisOnly = "Z Positive";
                    nameInfo.forLable = "Spiral Horizontal (Z Positive)";
                    nameInfo.forMenu = "Spiral Horizontal/Z Positive";
                    nameInfo.templateFileName = "Spiral";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralHorizontal_Z_Negative:
                    nameInfo.nameOnly = "Spiral Horizontal";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontal";
                    nameInfo.axisOnly = "Z Negative";
                    nameInfo.forLable = "Spiral Horizontal (Z Negative)";
                    nameInfo.forMenu = "Spiral Horizontal/Z Negative";
                    nameInfo.templateFileName = "Spiral";
                    break;


                case CurvedWorld.BEND_TYPE.SpiralHorizontalRolloff_X:
                    nameInfo.nameOnly = "Spiral Horizontal Rolloff";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontalRolloff";
                    nameInfo.axisOnly = "X";
                    nameInfo.forLable = "Spiral Horizontal Rolloff (X)";
                    nameInfo.forMenu = "Spiral Horizontal Rolloff/X";
                    nameInfo.templateFileName = "SpiralRolloff";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralHorizontalRolloff_Z:
                    nameInfo.nameOnly = "Spiral Horizontal Rolloff";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontalRolloff";
                    nameInfo.axisOnly = "Z";
                    nameInfo.forLable = "Spiral Horizontal Rolloff (Z)";
                    nameInfo.forMenu = "Spiral Horizontal Rolloff/Z";
                    nameInfo.templateFileName = "SpiralRolloff";
                    break;


                case CurvedWorld.BEND_TYPE.SpiralHorizontalDouble_X:
                    nameInfo.nameOnly = "Spiral Horizontal Double";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontalDouble";
                    nameInfo.axisOnly = "X";
                    nameInfo.forLable = "Spiral Horizontal Double (X)";
                    nameInfo.forMenu = "Spiral Horizontal Double/X";
                    nameInfo.templateFileName = "SpiralDouble";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralHorizontalDouble_Z:
                    nameInfo.nameOnly = "Spiral Horizontal Double";
                    nameInfo.nameOnlyWithoutSpace = "SpiralHorizontalDouble";
                    nameInfo.axisOnly = "Z";
                    nameInfo.forLable = "Spiral Horizontal Double (Z)";
                    nameInfo.forMenu = "Spiral Horizontal Double/Z";
                    nameInfo.templateFileName = "SpiralDouble";
                    break;


                case CurvedWorld.BEND_TYPE.SpiralVertical_X_Positive:
                    nameInfo.nameOnly = "Spiral Vertical";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVertical";
                    nameInfo.axisOnly = "X Positive";
                    nameInfo.forLable = "Spiral Vertical (X Positive)";
                    nameInfo.forMenu = "Spiral Vertical/X Positive";
                    nameInfo.templateFileName = "Spiral";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralVertical_X_Negative:
                    nameInfo.nameOnly = "Spiral Vertical";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVertical";
                    nameInfo.axisOnly = "X Negative";
                    nameInfo.forLable = "Spiral Vertical (X Negative)";
                    nameInfo.forMenu = "Spiral Vertical/X Negative";
                    nameInfo.templateFileName = "Spiral";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralVertical_Z_Positive:
                    nameInfo.nameOnly = "Spiral Vertical";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVertical";
                    nameInfo.axisOnly = "Z Positive";
                    nameInfo.forLable = "Spiral Vertical (Z Positive)";
                    nameInfo.forMenu = "Spiral Vertical/Z Positive";
                    nameInfo.templateFileName = "Spiral";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralVertical_Z_Negative:
                    nameInfo.nameOnly = "Spiral Vertical";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVertical";
                    nameInfo.axisOnly = "Z Negative";
                    nameInfo.forLable = "Spiral Vertical (Z Negative)";
                    nameInfo.forMenu = "Spiral Vertical/Z Negative";
                    nameInfo.templateFileName = "Spiral";
                    break;


                case CurvedWorld.BEND_TYPE.SpiralVerticalRolloff_X:
                    nameInfo.nameOnly = "Spiral Vertical Rolloff";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVerticalRolloff";
                    nameInfo.axisOnly = "X";
                    nameInfo.forLable = "Spiral Vertical Rolloff (X)";
                    nameInfo.forMenu = "Spiral Vertical Rolloff/X";
                    nameInfo.templateFileName = "SpiralRolloff";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralVerticalRolloff_Z:
                    nameInfo.nameOnly = "Spiral Vertical Rolloff";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVerticalRolloff";
                    nameInfo.axisOnly = "Z";
                    nameInfo.forLable = "Spiral Vertical Rolloff (Z)";
                    nameInfo.forMenu = "Spiral Vertical Rolloff/Z";
                    nameInfo.templateFileName = "SpiralRolloff";
                    break;


                case CurvedWorld.BEND_TYPE.SpiralVerticalDouble_X:
                    nameInfo.nameOnly = "Spiral Vertical Double";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVerticalDouble";
                    nameInfo.axisOnly = "X";
                    nameInfo.forLable = "Spiral Vertical Double (X)";
                    nameInfo.forMenu = "Spiral Vertical Double/X";
                    nameInfo.templateFileName = "SpiralDouble";
                    break;
                case CurvedWorld.BEND_TYPE.SpiralVerticalDouble_Z:
                    nameInfo.nameOnly = "Spiral Vertical Double";
                    nameInfo.nameOnlyWithoutSpace = "SpiralVerticalDouble";
                    nameInfo.axisOnly = "Z";
                    nameInfo.forLable = "Spiral Vertical Double (Z)";
                    nameInfo.forMenu = "Spiral Vertical Double/Z";
                    nameInfo.templateFileName = "SpiralDouble";
                    break;


                case CurvedWorld.BEND_TYPE.TwistedSpiral_X_Positive:
                    nameInfo.nameOnly = "Twisted Spiral";
                    nameInfo.nameOnlyWithoutSpace = "TwistedSpiral";
                    nameInfo.axisOnly = "X Positive";
                    nameInfo.forLable = "Twisted Spiral (X Positive)";
                    nameInfo.forMenu = "Twisted Spiral/X Positive";
                    nameInfo.templateFileName = "TwistedSpiral";
                    break;
                case CurvedWorld.BEND_TYPE.TwistedSpiral_X_Negative:
                    nameInfo.nameOnly = "Twisted Spiral";
                    nameInfo.nameOnlyWithoutSpace = "TwistedSpiral";
                    nameInfo.axisOnly = "X Negative";
                    nameInfo.forLable = "Twisted Spiral (X Negative)";
                    nameInfo.forMenu = "Twisted Spiral/X Negative";
                    nameInfo.templateFileName = "TwistedSpiral";
                    break;
                case CurvedWorld.BEND_TYPE.TwistedSpiral_Z_Positive:
                    nameInfo.nameOnly = "Twisted Spiral";
                    nameInfo.nameOnlyWithoutSpace = "TwistedSpiral";
                    nameInfo.axisOnly = "Z Positive";
                    nameInfo.forLable = "Twisted Spiral (Z Positive)";
                    nameInfo.forMenu = "Twisted Spiral/Z Positive";
                    nameInfo.templateFileName = "TwistedSpiral";
                    break;
                case CurvedWorld.BEND_TYPE.TwistedSpiral_Z_Negative:
                    nameInfo.nameOnly = "Twisted Spiral";
                    nameInfo.nameOnlyWithoutSpace = "TwistedSpiral";
                    nameInfo.axisOnly = "Z Negative";
                    nameInfo.forLable = "Twisted Spiral (Z Negative)";
                    nameInfo.forMenu = "Twisted Spiral/Z Negative";
                    nameInfo.templateFileName = "TwistedSpiral";
                    break;


            }

            return nameInfo;
        }

        static public GenericMenu BuildBendTypesMenu(CurvedWorld.BEND_TYPE _BendType, UnityEditor.GenericMenu.MenuFunction2 callback)
        {
            GenericMenu menu = new GenericMenu();

            foreach (CurvedWorld.BEND_TYPE bendType in Enum.GetValues(typeof(CurvedWorld.BEND_TYPE)))
            {
                menu.AddItem(new GUIContent(EditorUtilities.GetBendTypeNameInfo(bendType).forMenu), _BendType == bendType, callback, bendType);
            }

            return menu;
        }


        static public bool IsMaterialBuiltInResource(Material material)
        {
            if (material == null)
                return true;

            return IsMaterialBuiltInResource(AssetDatabase.GetAssetPath(material.GetInstanceID()));
        }

        static public bool IsMaterialBuiltInResource(string materialPath)
        {
            if (string.IsNullOrEmpty(materialPath) == false && materialPath.Contains("Assets") && materialPath.Contains(".mat"))
                return false;


            return true;
        }

        static public bool IsShaderBuiltInResource(Shader shader)
        {
            if (shader == null)
                return true;


            return IsShaderBuiltInResource(AssetDatabase.GetAssetPath(shader.GetInstanceID()));
        }

        static public bool IsShaderBuiltInResource(string shaderPath)
        {
            if (string.IsNullOrEmpty(shaderPath) == false && shaderPath.Contains("Assets") && shaderPath.Contains(".shader"))
                return false;


            return true;
        }


        static public bool StringIsCommented(string line)
        {
            //We need only uncomented line

            if (string.IsNullOrEmpty(line) || line.Length == 0)
                return true;

            line = line.TrimStart();

            return (line.IndexOf("//") == 0 ? true : false);
        }


        static public string GetKeywordName(CurvedWorld.BEND_TYPE bendType)
        {
            return shaderKeywordPrefix_BendType + bendType.ToString().ToUpperInvariant();
        }

        static public string GetKeywordName(int bendID)
        {
            return shaderKeywordPrefix_BendID + bendID;
        }

        static public RENDER_PIPELINE GetCurrentRenderPipeline()
        {
            if (UnityEngine.Rendering.GraphicsSettings.renderPipelineAsset == null)
                return RENDER_PIPELINE.Builtin;
            else
            {
                if (UnityEngine.Rendering.GraphicsSettings.renderPipelineAsset.name.Contains("Universal") ||
                    UnityEngine.Rendering.GraphicsSettings.renderPipelineAsset.name.Contains("URP"))
                    return RENDER_PIPELINE.Universal;
                else
                    return RENDER_PIPELINE.HighDefinition;
            }
        }

        static public bool CanGenerateUnityShaderGrap()
        {
#if UNITY_2021_3_OR_NEWER
            return true;
#else
            return GetCurrentRenderPipeline() == RENDER_PIPELINE.Builtin ? false : true;
#endif
        }

        static public bool CanGenerateAmplifyShaderFuntion()
        {
            if (amplifyShaderEditorWindowPath == null)
            {
                amplifyShaderEditorWindowPath = string.Empty;

                string[] assets = AssetDatabase.FindAssets("AmplifyShaderEditorWindow", null);
                if (assets != null && assets.Length > 0)
                {
                    for (int i = 0; i < assets.Length; i++)
                    {
                        if (string.IsNullOrEmpty(assets[i]) == false)
                        {
                            string filePath = AssetDatabase.GUIDToAssetPath(assets[i]);

                            if (filePath.Contains("AmplifyShaderEditor"))
                            {
                                amplifyShaderEditorWindowPath = filePath;
                                break;
                            }
                        }
                    }
                }
            }

            return string.IsNullOrEmpty(amplifyShaderEditorWindowPath) ? false : true;
        }


        static public ACTIVATE_STATE ActivateShader(string shaderFilePath, bool activate, bool reimport)
        {
            if (string.IsNullOrWhiteSpace(shaderFilePath) || File.Exists(shaderFilePath) == false)
                return ACTIVATE_STATE.Skip;


            string[] allLines = File.ReadAllLines(shaderFilePath);
            if (allLines == null || allLines.Length == 0)
                return ACTIVATE_STATE.Skip;


            bool hasProperty = false;
            bool hasBendType = false;
            bool hasBendID = false;
            bool hasPathtoCGINC = false;


            for (int i = 0; i < allLines.Length; i++)
            {
                //Material Property
                if (allLines[i].Contains("CurvedWorldBendSettings") && allLines[i].Contains(shaderProprtyName_BendSettings))
                {
                    allLines[i] = (activate ? string.Empty : "//") + (allLines[i].Contains("HideInInspector") ? "[HideInInspector]" : string.Empty) + "[CurvedWorldBendSettings] _CurvedWorldBendSettings(\"0|1|1\", Vector) = (0, 0, 0, 0)";

                    hasProperty = true;
                }

                //Bend Type keywords
                if (allLines[i].Contains(shaderKeywordPrefix_BendType))
                {
                    allLines[i] = (activate ? string.Empty : "//") + "#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE";

                    hasBendType = true;
                }

                //Bend ID keywords
                if (allLines[i].Contains(shaderKeywordPrefix_BendID))
                {
                    allLines[i] = (activate ? string.Empty : "//") + "#define CURVEDWORLD_BEND_ID_1";

                    hasBendID = true;
                }

                //Disable keyword
                if (allLines[i].Contains(shaderKeywordName_CurvedWorldDisabled) && allLines[i].Contains("#pragma"))
                {
                    allLines[i] = (activate ? string.Empty : "//") + "#pragma shader_feature_local " + shaderKeywordName_CurvedWorldDisabled;

                    hasBendID = true;
                }

                //Normal Transforamtion
                if (allLines[i].Contains(shaderKeywordName_BendTransformNormal) && allLines[i].Contains("#pragma"))
                {
                    allLines[i] = (activate ? string.Empty : "//") + "#pragma shader_feature_local " + shaderKeywordName_BendTransformNormal;

                    //has normal - not nessesary
                }

                //Path to the cginc
                if (allLines[i].Contains("Core/CurvedWorldTransform.cginc"))
                {
                    allLines[i] = (activate ? string.Empty : "//") + GetCoreTransformFilePathForShader();

                    hasPathtoCGINC = true;
                }
            }

            //Nothing changed
            if (hasProperty == false && hasBendType == false && hasBendID == false && hasPathtoCGINC == false)
                return ACTIVATE_STATE.Skip;

            //Problem detected
            if (hasProperty == false || hasBendType == false || hasBendID == false || hasPathtoCGINC == false)
            {
                string warningMessage = string.Format("Curved World {0} problem for shader at path '{1}'\nhasProperty: {2}\nhasBendType: {3}\nhasBendID: {4}\nhasPathtoCGINC: {5}\n", (activate ? "activation" : "deactivation"), shaderFilePath, hasProperty, hasBendType, hasBendID, hasPathtoCGINC);
                Debug.LogWarning(warningMessage);

                return ACTIVATE_STATE.Problem;
            }


            File.WriteAllLines(shaderFilePath, allLines);


            if (reimport)
                AssetDatabase.ImportAsset(shaderFilePath);


            return ACTIVATE_STATE.Done;
        }


        static public void CallbackFindController(object obj)
        {
            if (obj == null)
                return;

            //Format - (int)bendType + "_" + bendID

            string objString = obj.ToString();
            if (string.IsNullOrEmpty(objString))
                return;

            string[] info = objString.Split('_');
            if (info.Length != 2)
                return;


            CurvedWorld.BEND_TYPE bendType = (CurvedWorld.BEND_TYPE)0;
            int bendID = 0;

            int result;

            if (int.TryParse(info[0], out result))
            {
                if (result >= 0 && result < EditorUtilities.MAX_SUPPORTED_BEND_TYPES)
                    bendType = (CurvedWorld.BEND_TYPE)result;
                else
                    return;
            }

            if (int.TryParse(info[1], out result))
            {
                if (result > 0 && result <= EditorUtilities.MAX_SUPPORTED_BEND_IDS)
                    bendID = result;
                else
                    return;
            }

            CurvedWorld.CurvedWorldController[] sceneControllers = Resources.FindObjectsOfTypeAll<CurvedWorld.CurvedWorldController>();
            if (sceneControllers != null && sceneControllers.Length > 0)
            {
                for (int i = 0; i < sceneControllers.Length; i++)
                {
                    if (sceneControllers[i] != null &&
                       sceneControllers[i].bendType == bendType &&
                       sceneControllers[i].bendID == bendID)
                    {
                        Selection.activeGameObject = sceneControllers[i].gameObject;
                        return;
                    }
                }
            }

            Debug.LogWarning("Can not find 'CurvedWorld.Controller' script with BendType: " + EditorUtilities.GetBendTypeNameInfo(bendType).forLable + " and BendID: " + bendID + ".\n");
        }

        static public void CallbackAnalyzeShaderCurvedWorldKeywords(object obj)
        {
            if (obj == null)
                return;

            Shader shader = (Shader)obj;
            if (shader == null)
                return;


            if (CurvedWorldEditorWindow.activeWindow == null)
                CurvedWorldEditorWindow.ShowWindow();

            if (CurvedWorldEditorWindow.activeWindow != null)
            {
                CurvedWorldEditorWindow.activeWindow.gTab = CurvedWorldEditorWindow.TAB.CurvedWorldKeywords;
                CurvedWorldEditorWindow.activeWindow.gCurvedWorldKeywordsShader = shader;
                CurvedWorldEditorWindow.gCurvedWorldKeywordsShaderInfo = null;

                CurvedWorldEditorWindow.activeWindow.Repaint();
            }
        }

        static public void CallbackReimportShader(object obj)
        {
            if (obj == null)
                return;

            Shader shader = (Shader)obj;
            if (shader == null)
                return;


            string shaderPath = AssetDatabase.GetAssetPath(shader.GetInstanceID());
            if (EditorUtilities.IsShaderBuiltInResource(shaderPath) == false)
            {
                AssetDatabase.ImportAsset(shaderPath);
            }
        }

        static public void CallbackOpenCurvedWorldSettingsWindow(object obj)
        {
            if (CurvedWorldEditorWindow.activeWindow == false)
                CurvedWorldEditorWindow.ShowWindow();


            //Select bendType and ID
            //Format - (int)bendType + "_" + bendID

            string objString = obj.ToString();
            if (string.IsNullOrEmpty(objString))
                return;

            string[] info = objString.Split('_');
            if (info.Length != 2)
                return;


            CurvedWorld.BEND_TYPE bendType = (CurvedWorld.BEND_TYPE)0;
            int bendID = 0;

            int result;

            if (int.TryParse(info[0], out result))
            {
                if (result >= 0 && result < EditorUtilities.MAX_SUPPORTED_BEND_TYPES)
                    bendType = (CurvedWorld.BEND_TYPE)result;
                else
                    return;
            }

            if (int.TryParse(info[1], out result))
            {
                if (result > 0 && result <= EditorUtilities.MAX_SUPPORTED_BEND_IDS)
                    bendID = result;
                else
                    return;
            }


            CurvedWorldEditorWindow.activeWindow.gTab = CurvedWorldEditorWindow.TAB.Manage;
            CurvedWorldEditorWindow.activeWindow.gBendType = bendType;
            CurvedWorldEditorWindow.activeWindow.gBendID = bendID;
        }

        static public void CallbackOpenCurvedWorldSettingsWindowControllers()
        {
            if (CurvedWorldEditorWindow.activeWindow == false)
                CurvedWorldEditorWindow.ShowWindow();


            CurvedWorldEditorWindow.activeWindow.gTab = CurvedWorldEditorWindow.TAB.Controllers;
        }


        static internal Texture2D LoadTexture(string resourceName, TextureWrapMode wrapMode, bool linear)
        {
            Texture2D texture = (Texture2D)UnityEditor.AssetDatabase.LoadAssetAtPath(Path.Combine(GetCurvedWorldEditorFolderPath(), "Editor", "Icons", resourceName + ".png"), typeof(Texture2D));

            if (texture != null)
                texture.wrapMode = wrapMode;

            return texture;
        }


        static public string ConvertPathToProjectRelative(string path)
        {
            //Before using this method, make sure path 'is' project relative

            return NormalizePath("Assets" + path.Substring(Application.dataPath.Length));
        }
        static public bool IsPathProjectRelative(string path)
        {
            if (string.IsNullOrWhiteSpace(path))
                return false;

            if (Directory.Exists(path) == false)
                return false;

            if (path.IndexOf("Assets") == 0)
                return true;


            return NormalizePath(path).Contains(NormalizePath(Application.dataPath));
        }
        static string NormalizePath(string path)
        {
            if (string.IsNullOrWhiteSpace(path))
                return path;
            else
                return path.Replace("//", "/").Replace("\\\\", "/").Replace("\\", "/");
        }



        static public string RemoveInvalidCharacters(string name)
        {
            if (string.IsNullOrEmpty(name))
                return string.Empty;
            else
            {
                if (name.IndexOfAny(invalidFileNameCharachters) == -1)
                    return name;
                else
                    return string.Concat(name.Split(invalidFileNameCharachters, StringSplitOptions.RemoveEmptyEntries));
            }
        }
        static public bool ContainsInvalidFileNameCharacters(string name)
        {
            if (string.IsNullOrEmpty(name))
                return false;
            else
                return name.IndexOfAny(invalidFileNameCharachters) >= 0;
        }

        public struct BendTypeNameInfo
        {
            public string nameOnly;
            public string nameOnlyWithoutSpace;
            public string forLable;
            public string forMenu;
            public string axisOnly;
            public string templateFileName;
        }

        public class MaterialInfo
        {
            public Material material;
            public bool isBuiltInresource;
            public bool existsInScene;

            public MaterialInfo(Material mat)
            {
                material = mat;

                isBuiltInresource = EditorUtilities.IsMaterialBuiltInResource(mat);

                existsInScene = true;
            }
        }

        public class ShaderOverview
        {
            public Shader shader;
            public bool isShaderUnityBuiltInResource;

            public List<MaterialInfo> materialsInfo;
            public string[] keywordsArray;
            public string keywordsString;
            public string keywordsTooltip;

            HashSet<string> keywordsHashSet;

            public int hashCode;

            public bool foldout;

            public ShaderOverview(Material material)
            {
                shader = material.shader;

                isShaderUnityBuiltInResource = IsShaderBuiltInResource(shader);


                AddMaterial(material);

                KeywordsHasChanged(material.shaderKeywords);
            }

            public void AddMaterial(Material mat)
            {
                if (materialsInfo == null)
                    materialsInfo = new List<MaterialInfo>();


                if (mat != null && materialsInfo.Any(m => m.material == mat) == false)
                {
                    materialsInfo.Add(new MaterialInfo(mat));
                }
            }

            public void SetNewKeywords(string keywords)
            {
                if (keywords == null)
                    return;


                string[] newKeywords = keywords.Replace(',', ' ').Replace('.', ' ').Replace(System.Environment.NewLine, " ").Replace("\n", " ").Split(' ').Where(k => string.IsNullOrEmpty(k.Trim()) == false).ToArray();

                for (int i = 0; i < materialsInfo.Count; i++)
                {
                    if (materialsInfo[i] != null && materialsInfo[i].material != null && materialsInfo[i].isBuiltInresource == false)
                    {
                        Undo.RecordObject(materialsInfo[i].material, "Change keywords");
                        materialsInfo[i].material.shaderKeywords = newKeywords;
                    }
                }


                KeywordsHasChanged(newKeywords);

                AssetDatabase.SaveAssets();
            }

            void KeywordsHasChanged(string[] keywords)
            {
                keywordsArray = keywords;
                if (string.IsNullOrEmpty(string.Concat(keywordsArray)))
                {
                    keywordsString = "Keywords:   None";
                    keywordsTooltip = string.Empty;
                }
                else
                {
                    keywordsString = "Keywords (" + keywordsArray.Length + "):   " + string.Join(",   ", keywordsArray.OrderBy(s => s));

                    keywordsTooltip = string.Join("\n", keywordsArray.OrderBy(s => s));
                }


                keywordsHashSet = new HashSet<string>(keywordsArray);

                hashCode = (shader.name + keywordsTooltip).GetHashCode();
            }

            public bool AllMaterialsAreBuiltInResources()
            {
                bool value = true;

                if (materialsInfo != null)
                {
                    for (int i = 0; i < materialsInfo.Count; i++)
                    {
                        if (materialsInfo[i] != null && materialsInfo[i].material != null && materialsInfo[i].isBuiltInresource == false)
                        {
                            value = false;
                            break;
                        }
                    }
                }

                return value;
            }

            public bool ContainSameKeywords(string[] array)
            {
                HashSet<string> hSet = new HashSet<string>(array);
                bool value = keywordsHashSet.SetEquals(hSet);

                return value;
            }
        }

        public class ShaderCurvedWorldKeywordsInfo
        {
            public CurvedWorld.BEND_TYPE[] supportedBendTypes;
            public bool[] selectedBendTypes;

            public int[] supportedBendIDs;
            public bool[] selectedBendIDs;

            public bool supportedMultiCompile;
            public bool selecedMultiCompile;


            public ShaderCurvedWorldKeywordsInfo(Shader shader)
            {
                supportedBendTypes = null;
                selectedBendTypes = null;
                bool hasNormalTransform;


                if (shader == false || EditorUtilities.HasShaderCurvedWorldBendSettingsProperty(shader) == false)
                    return;


                EditorUtilities.GetShaderSupportedBendSettings(shader, out supportedBendTypes, out supportedBendIDs, out hasNormalTransform);

                if (supportedBendTypes != null && supportedBendIDs != null)
                {
                    selectedBendTypes = new bool[MAX_SUPPORTED_BEND_TYPES];
                    for (int i = 0; i < MAX_SUPPORTED_BEND_TYPES; i++)
                    {
                        selectedBendTypes[i] = supportedBendTypes.Contains((CurvedWorld.BEND_TYPE)i);
                    }

                    selectedBendIDs = new bool[EditorUtilities.MAX_SUPPORTED_BEND_IDS];
                    for (int i = 0; i < EditorUtilities.MAX_SUPPORTED_BEND_IDS; i++)
                    {
                        selectedBendIDs[i] = supportedBendIDs.Contains(i + 1);
                    }


                    //Check multi_compile
                    string shaderFilePath = AssetDatabase.GetAssetPath(shader.GetInstanceID());

                    string[] allLines = File.ReadAllLines(shaderFilePath);
                    for (int i = 0; i < allLines.Length; i++)
                    {
                        if (allLines[i].Contains("#"))
                        {
                            if (allLines[i].Contains(shaderKeywordPrefix_BendType))
                            {
                                supportedMultiCompile = allLines[i].Contains("multi_compile_local");

                                selecedMultiCompile = supportedMultiCompile;

                                break;
                            }
                        }
                    }
                }
            }


            public bool IsCurvedWorldShader()
            {
                if (supportedBendTypes != null &&
                    supportedBendIDs != null)
                    return true;
                else
                    return false;
            }

            public CurvedWorld.BEND_TYPE[] GetSelectedBendTypes()
            {
                List<CurvedWorld.BEND_TYPE> bendTypes = new List<CurvedWorld.BEND_TYPE>();
                for (int i = 0; i < EditorUtilities.MAX_SUPPORTED_BEND_TYPES; i++)
                {
                    if (selectedBendTypes[i])
                        bendTypes.Add((CurvedWorld.BEND_TYPE)i);
                }

                return bendTypes.ToArray();
            }

            public int[] GetSelectedBendIDs()
            {
                List<int> bendIDs = new List<int>();
                for (int i = 0; i < EditorUtilities.MAX_SUPPORTED_BEND_IDS; i++)
                {
                    if (selectedBendIDs[i])
                        bendIDs.Add(i + 1);     //ID indexes start from 1, not 0
                }

                return bendIDs.ToArray();
            }
        }

        public static bool Contains(this string source, string toCheck, bool ingnoreCase)
        {
            return source?.IndexOf(toCheck, ingnoreCase ? StringComparison.OrdinalIgnoreCase : StringComparison.Ordinal) >= 0;
        }
    }
}