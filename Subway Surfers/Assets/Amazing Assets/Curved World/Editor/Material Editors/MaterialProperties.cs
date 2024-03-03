using System;

using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    static public class MaterialProperties
    {
        public enum STYLE { None, Standard, HelpBox, Foldout }

        public enum BlendMode
        {
            Opaque,
            Cutout,
            Fade,   // Old school alpha-blending mode, fresnel does not affect amount of transparency
            Transparent // Physically plausible transparency mode, implemented as alpha pre-multiply
        }
        private static class Label
        {
            public static string mainGroupName = "Curved World";

            public static string bendType = "Bend Type";
            public static string bendID = "Bend ID";
            public static string bendTransformNormal = "Transform Normal";

            public static string renderingMode = "Rendering Mode";
            public static string renderFace = "Render Face";

            public static readonly string[] blendNames = Enum.GetNames(typeof(BlendMode));
        }

        static MaterialProperty _CurvedWorldBendSettings = null;

        static MaterialProperty _BlendMode = null;
        static MaterialProperty _Cull = null;

        static Material material;

        static bool foldout = true;


        static public void InitCurvedWorldMaterialProperties(MaterialProperty[] props)
        {
            _CurvedWorldBendSettings = FindProperty(EditorUtilities.shaderProprtyName_BendSettings, props, false);

            _BlendMode = FindProperty("_Mode", props, false);
            _Cull = FindProperty("_Cull", props, false);

        }

        static public void DrawCurvedWorldMaterialProperties(MaterialEditor materialEditor, STYLE style, bool drawRenderingOptions, bool drawCull)
        {
            if (drawRenderingOptions && _BlendMode != null)
            {
                //Make sure that needed setup(ie keywords / renderqueue) are set up if we're switching some existing
                Material material = materialEditor.target as Material;
                SetupMaterialWithBlendMode(material, (BlendMode)material.GetFloat("_Mode"));  //If blend modes are not available - use default blend mode
            }

            switch (style)
            {
                case STYLE.HelpBox:
                    {
                        using (new EditorGUIHelper.EditorGUILayoutBeginVertical(EditorStyles.helpBox))
                        {
                            EditorGUILayout.LabelField(Label.mainGroupName, EditorStyles.boldLabel);

                            if (_CurvedWorldBendSettings != null)
                                materialEditor.ShaderProperty(_CurvedWorldBendSettings, Label.bendType);
                        }

                        GUILayout.Space(5);
                    }
                    break;

                case STYLE.Standard:
                    {
                        EditorGUILayout.LabelField(Label.mainGroupName, EditorStyles.boldLabel);

                        if (_CurvedWorldBendSettings != null)
                            materialEditor.ShaderProperty(_CurvedWorldBendSettings, Label.bendType);

                        GUILayout.Space(5);

                    }
                    break;

                case STYLE.Foldout:
                    {
                        foldout = EditorGUILayout.BeginFoldoutHeaderGroup(foldout, Label.mainGroupName);

                        if (foldout)
                        {
                            if (_CurvedWorldBendSettings != null)
                                materialEditor.ShaderProperty(_CurvedWorldBendSettings, Label.bendType);

                            GUILayout.Space(5);
                        }

                        EditorGUILayout.EndFoldoutHeaderGroup();
                    }
                    break;

                case STYLE.None:
                default:
                    {
                        if (_CurvedWorldBendSettings != null)
                            materialEditor.ShaderProperty(_CurvedWorldBendSettings, Label.bendType);
                    }
                    break;
            }



            if (drawRenderingOptions && _BlendMode != null)
            {
                EditorGUI.BeginChangeCheck();
                {
                    BlendModePopup(materialEditor);
                }
                if (EditorGUI.EndChangeCheck())
                {
                    foreach (var obj in _BlendMode.targets)
                    {
                        Material mat = (Material)obj;
                        SetupMaterialWithBlendMode(mat, (BlendMode)mat.GetFloat("_Mode"));
                    }
                }
            }

            if (drawCull && _Cull != null)
            {
                materialEditor.ShaderProperty(_Cull, Label.renderFace);
            }
        }

        static public void SetKeyWords(Material material)
        {
            if (material.HasProperty(EditorUtilities.shaderProprtyName_BendSettings))
            {
                CurvedWorld.BEND_TYPE bendType;
                int bendID;
                bool normalTransform;

                EditorUtilities.GetBendSettingsFromVector(material.GetVector(EditorUtilities.shaderProprtyName_BendSettings), out bendType, out bendID, out normalTransform);

                EditorUtilities.UpdateMaterialKeyWords(material, bendType, bendID, normalTransform);
            }
        }

        static public MaterialProperty FindProperty(string propertyName, MaterialProperty[] properties, bool mandatory = true)
        {
            for (int index = 0; index < properties.Length; ++index)
            {
                if (properties[index] != null && properties[index].name == propertyName)
                    return properties[index];
            }

            if (mandatory)
                throw new System.ArgumentException("Could not find MaterialProperty: '" + propertyName + "', Num properties: " + (object)properties.Length);
            else
                return null;
        }

        static void BlendModePopup(MaterialEditor materialEditor)
        {
            EditorGUI.showMixedValue = _BlendMode.hasMixedValue;
            var mode = (BlendMode)_BlendMode.floatValue;

            EditorGUI.BeginChangeCheck();
            mode = (BlendMode)EditorGUILayout.Popup(Label.renderingMode, (int)mode, Label.blendNames);
            if (EditorGUI.EndChangeCheck())
            {
                materialEditor.RegisterPropertyChangeUndo("Rendering Mode");
                _BlendMode.floatValue = (float)mode;
            }

            EditorGUI.showMixedValue = false;
        }

        static void SetupMaterialWithBlendMode(Material material, BlendMode blendMode)
        {
            switch (blendMode)
            {
                case BlendMode.Opaque:
                    material.SetOverrideTag("RenderType", "CurvedWorld_Opaque");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = -1;
                    break;
                case BlendMode.Cutout:
                    material.SetOverrideTag("RenderType", "CurvedWorld_TransparentCutout");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.EnableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;
                    break;
                case BlendMode.Fade:
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    material.SetInt("_ZWrite", 0);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.EnableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                    break;
                case BlendMode.Transparent:
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    material.SetInt("_ZWrite", 0);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.EnableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                    break;
            }
        }
    }
}