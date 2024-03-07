using UnityEngine;
using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    class SpeedTree8ShaderGUI : ShaderGUI
    {
        private bool m_FirstTimeApply = true;

        private static void MakeAlignedProperty(MaterialProperty prop, GUIContent text, MaterialEditor materialEditor, bool doubleWide = false)
        {
            Rect position = EditorGUILayout.GetControlRect(true, UnityEditor.EditorGUIUtility.singleLineHeight + 2f, new GUILayoutOption[0]);
            position.width = UnityEditor.EditorGUIUtility.labelWidth + (UnityEditor.EditorGUIUtility.fieldWidth * (doubleWide ? 2f : 1f));
            materialEditor.ShaderProperty(position, prop, text);
        }

        private static void MakeCheckedProperty(MaterialProperty keywordToggleProp, MaterialProperty prop, GUIContent text, MaterialEditor materialEditor, bool doubleWide = false)
        {
            Rect position = EditorGUILayout.GetControlRect(true, UnityEditor.EditorGUIUtility.singleLineHeight + 2f, new GUILayoutOption[0]);
            position.width = UnityEditor.EditorGUIUtility.labelWidth + (UnityEditor.EditorGUIUtility.fieldWidth / 2f);
            materialEditor.ShaderProperty(position, keywordToggleProp, text);
            using (new EditorGUI.DisabledScope(keywordToggleProp.floatValue == 0f))
            {
                position.width = UnityEditor.EditorGUIUtility.labelWidth + (UnityEditor.EditorGUIUtility.fieldWidth * (doubleWide ? 2f : 1f));
                Rect rectPtr1 = position;
                rectPtr1.x += UnityEditor.EditorGUIUtility.fieldWidth / 2f;
                materialEditor.ShaderProperty(rectPtr1, prop, " ");
            }
        }

        private static void MaterialChanged(Material material)
        {
            SetKeyword(material, "EFFECT_BUMP", material.GetInt("_NormalMapKwToggle") == 1);

            SetKeyword(material, "EFFECT_SUBSURFACE", material.GetInt("_SubsurfaceKwToggle") == 1);

            SetKeyword(material, "EFFECT_BILLBOARD", material.GetInt("_BillboardKwToggle") == 1);

            SetKeyword(material, "EFFECT_EXTRA_TEX", (bool)material.GetTexture("_ExtraTex"));
        }

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            if (this.m_FirstTimeApply)
            {
                UnityEngine.Object[] targets = materialEditor.targets;
                int index = 0;
                while (true)
                {
                    if (index >= targets.Length)
                    {
                        this.m_FirstTimeApply = false;
                        break;
                    }
                    UnityEngine.Object obj2 = targets[index];
                    MaterialChanged((Material)obj2);
                    index++;
                }
            }
            UnityEditor.EditorGUIUtility.labelWidth = 0f;
            EditorGUI.BeginChangeCheck();

            AmazingAssets.CurvedWorldEditor.MaterialProperties.InitCurvedWorldMaterialProperties(properties);
            AmazingAssets.CurvedWorldEditor.MaterialProperties.DrawCurvedWorldMaterialProperties(materialEditor, AmazingAssets.CurvedWorldEditor.MaterialProperties.STYLE.HelpBox, false, false);



            GUILayout.Label(Styles.primaryMapsText, EditorStyles.boldLabel, new GUILayoutOption[0]);
            MaterialProperty textureProp = FindProperty("_MainTex", properties);
            MaterialProperty property2 = FindProperty("_Color", properties);
            materialEditor.TexturePropertySingleLine(Styles.colorText, textureProp, null, property2);
            MaterialProperty property3 = FindProperty("_BumpMap", properties);
            materialEditor.TexturePropertySingleLine(Styles.normalMapText, property3);
            MaterialProperty property4 = FindProperty("_ExtraTex", properties);
            materialEditor.TexturePropertySingleLine(Styles.extraMapText, property4, null);
            if (property4.textureValue == null)
            {
                MaterialProperty property9 = FindProperty("_Glossiness", properties);
                materialEditor.ShaderProperty(property9, Styles.smoothnessText, 2);
                MaterialProperty property10 = FindProperty("_Metallic", properties);
                materialEditor.ShaderProperty(property10, Styles.metallicText, 2);
            }
            MaterialProperty property5 = FindProperty("_SubsurfaceTex", properties);
            MaterialProperty property6 = FindProperty("_SubsurfaceColor", properties);
            materialEditor.TexturePropertySingleLine(Styles.subsurfaceMapText, property5, null, property6);
            EditorGUILayout.Space();
            GUILayout.Label(Styles.optionsText, EditorStyles.boldLabel, new GUILayoutOption[0]);
            MakeAlignedProperty(FindProperty("_TwoSided", properties), Styles.twoSidedText, materialEditor, true);
            MakeAlignedProperty(FindProperty("_WindQuality", properties), Styles.windQualityText, materialEditor, true);
            MakeCheckedProperty(FindProperty("_HueVariationKwToggle", properties), FindProperty("_HueVariationColor", properties), Styles.hueVariationText, materialEditor, false);
            MakeAlignedProperty(FindProperty("_NormalMapKwToggle", properties), Styles.normalMappingText, materialEditor, true);
            MaterialProperty prop = FindProperty("_SubsurfaceKwToggle", properties);
            MakeAlignedProperty(prop, Styles.subsurfaceText, materialEditor, true);
            if (prop.floatValue > 0f)
            {
                MaterialProperty property11 = FindProperty("_SubsurfaceIndirect", properties);
                materialEditor.ShaderProperty(property11, Styles.subsurfaceIndirectText, 2);
            }
            MaterialProperty property8 = FindProperty("_BillboardKwToggle", properties);
            MakeAlignedProperty(property8, Styles.billboardText, materialEditor, true);
            if (property8.floatValue > 0f)
            {
                MaterialProperty property12 = FindProperty("_BillboardShadowFade", properties);
                materialEditor.ShaderProperty(property12, Styles.billboardShadowFadeText, 2);
            }
            if (EditorGUI.EndChangeCheck())
            {
                foreach (UnityEngine.Object obj3 in materialEditor.targets)
                {
                    Material material = (Material)obj3;
                    MaterialChanged(material);

                    AmazingAssets.CurvedWorldEditor.MaterialProperties.SetKeyWords(material);

                }
            }
            EditorGUILayout.Space();
            GUILayout.Label(Styles.advancedText, EditorStyles.boldLabel, new GUILayoutOption[0]);
            materialEditor.EnableInstancingField();
            materialEditor.DoubleSidedGIField();
        }

        private static void SetKeyword(Material m, string keyword, bool state)
        {
            if (state)
            {
                m.EnableKeyword(keyword);
            }
            else
            {
                m.DisableKeyword(keyword);
            }
        }

        private static class Styles
        {
            public static GUIContent colorText = UnityEditor.EditorGUIUtility.TrTextContent("Color", "Color (RGB) and Opacity (A)", (Texture)null);
            public static GUIContent normalMapText = UnityEditor.EditorGUIUtility.TrTextContent("Normal", "Normal (RGB)", (Texture)null);
            public static GUIContent extraMapText = UnityEditor.EditorGUIUtility.TrTextContent("Extra", "Smoothness (R), Metallic (G), AO (B)", (Texture)null);
            public static GUIContent subsurfaceMapText = UnityEditor.EditorGUIUtility.TrTextContent("Subsurface", "Subsurface (RGB)", (Texture)null);
            public static GUIContent smoothnessText = UnityEditor.EditorGUIUtility.TrTextContent("Smoothness", "Smoothness value", (Texture)null);
            public static GUIContent metallicText = UnityEditor.EditorGUIUtility.TrTextContent("Metallic", "Metallic value", (Texture)null);
            public static GUIContent twoSidedText = UnityEditor.EditorGUIUtility.TrTextContent("Two-Sided", "Set this material to render as two-sided", (Texture)null);
            public static GUIContent windQualityText = UnityEditor.EditorGUIUtility.TrTextContent("Wind Quality", "Wind quality setting", (Texture)null);
            public static GUIContent hueVariationText = UnityEditor.EditorGUIUtility.TrTextContent("Hue Variation", "Hue variation Color (RGB) and Amount (A)", (Texture)null);
            public static GUIContent normalMappingText = UnityEditor.EditorGUIUtility.TrTextContent("Normal Map", "Enable normal mapping", (Texture)null);
            public static GUIContent subsurfaceText = UnityEditor.EditorGUIUtility.TrTextContent("Subsurface", "Enable subsurface scattering", (Texture)null);
            public static GUIContent subsurfaceIndirectText = UnityEditor.EditorGUIUtility.TrTextContent("Indirect Subsurface", "Scalar on subsurface from indirect light", (Texture)null);
            public static GUIContent billboardText = UnityEditor.EditorGUIUtility.TrTextContent("Billboard", "Enable billboard features (crossfading, etc.)", (Texture)null);
            public static GUIContent billboardShadowFadeText = UnityEditor.EditorGUIUtility.TrTextContent("Shadow Fade", "Fade shadow effect on billboards", (Texture)null);
            public static GUIContent primaryMapsText = UnityEditor.EditorGUIUtility.TrTextContent("Maps", null, (Texture)null);
            public static GUIContent optionsText = UnityEditor.EditorGUIUtility.TrTextContent("Options", null, (Texture)null);
            public static GUIContent advancedText = UnityEditor.EditorGUIUtility.TrTextContent("Advanced Options", null, (Texture)null);
        }
    }
}

