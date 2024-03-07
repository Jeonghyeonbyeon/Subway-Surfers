using UnityEditor;


namespace AmazingAssets.CurvedWorldEditor
{
    internal class SpritesShaderGUI : ShaderGUI
    {
        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            CurvedWorldEditor.MaterialProperties.InitCurvedWorldMaterialProperties(properties);
            CurvedWorldEditor.MaterialProperties.DrawCurvedWorldMaterialProperties(materialEditor, MaterialProperties.STYLE.HelpBox, false, true);

            base.OnGUI(materialEditor, properties);
        }
    }
}